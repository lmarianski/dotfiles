#!/usr/bin/env node

const fs = require("fs");
const os = require("os");
const path = require("path");
const util = require("util");
const { execFileSync, spawn, spawnSync, execSync: $ } = require("child_process")

const spawnPromise = util.promisify(spawnSync);

const username = execFileSync("keybase", ["whoami"]).toString().trim();
const kbfs_dir = execFileSync("keybase", ["config", "get", "-b", "mountdir"]).toString().trim();
const pc_name  = os.hostname();

const tmp_dir = os.tmpdir();//fs.mkdtempSync("backup_");
const file_dir = path.join(os.homedir(), "Dokumenty");
const backup_dir = path.join(kbfs_dir, "private", username, "backups", pc_name);

const archive_name = `backup-${date()}.tar.gz`;

const tmp_path = path.join(tmp_dir, archive_name);
const out_path = path.join(backup_dir, archive_name);

function date(debug) {
    return !debug ? new Date()
        .toLocaleString()
        .replace(/[:-]/g, "")
        .replace(" ", "_") : "2020412_131728";
}

const getGitRepos = async (cwd) => {
    const ff = path.parse(cwd);
    
    const out = $(`fd -x printf '"{//}",' \\; -H -E node_modules "^.git$" .`, {
        cwd
    }).toString().trim();
    const gitRepos = eval(`[${out}]`).map(el => path.relative(ff.dir, path.join(ff.name, el)));

    return gitRepos;
}

const bundleRepos = async (gitRepos) => {
    const gitTasks = [];

    gitRepos.forEach(el => {
        const p = path.parse(el);

        if (fs.existsSync(el)) {
            gitTasks.push(new Promise((resolve, reject) => {
                const proc = spawn("git", [
                    "bundle", "create", `../${p.name}.bundle`, "--all"
                ], {cwd:el,shell:true});

                proc.on("exit", () => {
                    console.log(el)
                    resolve();
                })
            }))
        }
    });

    await Promise.all(gitTasks);
    return;
}

const cleanupBundles = async (gitRepos) => {
    const gitTasks = [];

    gitRepos.forEach(el => {
        const p = path.parse(el);
    
        gitTasks.push(spawnPromise("rm", [
            `../${p.name}.bundle`
        ], {cwd:el}))
    });

    await Promise.all(gitTasks);
    return;
}

const makeBackup = (cwd, files, target, excludes=[]) => {
    return new Promise((resolve, reject) => {
        const x = [];

        excludes.forEach(el => {
            x.push("--exclude");
            x.push(el);
        })
        
        const tar = spawn("tar", [
            ...x,
            "--exclude",
            "*node_modules*",
            "--exclude",
            "Projects/Mods/*/build",
            //"--exclude",
            //"*ShaderCache",
            "--exclude-ignore-recursive=.gitignore",
            "--exclude-ignore-recursive=.tarignore",
            "--exclude-tag-all=.tarignore",
            "-cavf",
            target,
            ...(typeof files === "string" ? [files] : files)
        ], {cwd, stdio: "inherit"})

        tar.on("error", (err) => {reject(err);})
        tar.on("exit", resolve)
    });
}

(async () => {

    const ff = path.parse(file_dir);

    // console.log("Bundling git repos for archivization...");
    // const gitRepos = await getGitRepos(file_dir);
    // await bundleRepos(gitRepos);

    console.log("Archiving...");
    await makeBackup(ff.dir, file_dir, tmp_path);

    console.log("Copying archive to KBFS...");
    execFileSync("mkdir", ["-p", backup_dir]);
    spawnSync("rsync", ["-aP", tmp_path, out_path], {stdio:"inherit"});

    console.log("Cleaning up...");
    spawnSync("rm", [tmp_path]);
    if (tmp_dir != os.tmpdir()) {
        spawnSync("rmdir", [tmp_dir], {
            stdio: "inherit"
        });
    }

    // await cleanupBundles(gitRepos);

})();


