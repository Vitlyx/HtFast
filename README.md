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
    cd git_cmds
    sudo chmod +x setup.sh
    ```

    Enter your password when prompted.

6. Run the setup script:

    ```bash
    cd -P
    ./git_cmds/setup.sh {Your Password} {Cloudflare Token}
    ```

Once the setup script has finished running, you're all set!

## Usage

To use the system, go back to your terminal and run the following command:

```bash
./git_cmds/run.sh {git_repo} {setup_cmd}