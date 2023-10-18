# Git Cmds

Welcome to git_cmds. We provide the best of the best for your homelab server, creating projects that you have never seen before. Let's get started!

**P.S. Only supports Linux.**

## Setup

1. Create a Cloudflare account and a zero trust account.
2. Head over to Access and select Tunnels.
3. Click Create a Tunnel and give it a name.
4. In the Install and run a connector section, select Docker and copy the command. You'll need it later.
5. Run the following command to make the setup script executable:

    ```bash
    sudo chmod +x git_cmd/setup/setup.sh
    ```

    Enter your password when prompted.

6. Run the setup script:

    ```bash
    cd -P
    ./git_cmds/setup/setup.sh {Your Password} {Cloudflare Token}
    ```

Once the setup script has finished running, you're all set!

## Usage

To use the system, go back to your terminal and run the following command:

```bash
./git_cmds/run.sh {git_repo} {setup_cmd}
```

## Uninstall

If ever wanted to uninstall this program, don't worry we made it easy! Just simply run this command:

```bash
./git_cmds/uninstall.sh
```

## Update

To update your password (if ever changed), enter the following command:

```bash
nano git_cmds/config.sh
```

From here, edit your password and/or cloudflare docker token.

## Notice

1. Any of your info will **NOT** be shared with anyone.
2. Be warned if anything is edited, it is **NOT** our fault if broken, please reinstall it again.
3. If anything, please take a look into Cloudflares Terms of Service and Use.

## Thanks

Thank you for using our services, we hope you enjoy them, but be on the lookout for more updates for this repository, as some updates might be crucial.