# Control Network as Code

This project explores network control as code.

Quick start & Deployment Guide

Depending on your target environment, you can either provision a self-hosted GitHub agent or spin up the environment quickly for local testing.

### Option A: Secure Production Host Provisioning (Recommended)

Follow this sequence to isolate execution privileges using your custom application user (e.g., `github-runner`) and enforce directory security boundaries (`chmod 700`).

1. **Clone the repository and run the host initialization script:**
   The script automatically detects your current directory, registers the system user, and locks permissions.
   ```bash
   git clone https://github.com/wirkentod/net-as-code.git
   cd net-as-code
   chmod +x init-runner.sh
   sudo ./init-runner.sh github-runner
   ```

2. **Switch contexts to your secure user and navigate to the project directory dynamically:**
   Save the current project location in a temporary variable so you can change to the secure user context and return to the exact same path instantly:
   ```bash
   # Save path, switch user, and return to the exact same directory
   CURRENT_PATH=$PWD
   sudo -i -u github-runner cd "$CURRENT_PATH"
   ```

3. **Initialize credentials and activate the secure python environment:**
   Prepare your local variables from the template and run the setup engine using `source` to automatically create the virtual environment and encrypt your secrets file natively via Ansible Vault:
   ```bash
   mv vars_secrets.yaml.example vars_secrets.yaml
   # Edit your real secrets inside vars_secrets.yaml first, then execute:
   source setup.sh vars_secrets.yaml
   ```

4. **Verify execution manually before automation:**
   ```bash
   ansible-playbook site-playbook.yaml -i inventory.yaml -e @vars_secrets.yaml
   ```

5. **Download and configure the GitHub Actions Runner:**
   While logged in as the secure user, go to your GitHub Repository web page (`Settings -> Actions -> Runners -> New self-hosted runner`), select **Linux**, and execute the provided download commands inside the runner's home path. Remember to assign the mandatory label `net-control`:
   ```bash
   # Create and enter the installation folder inside the runner's home directory
   mkdir ~/actions-runner && cd ~/actions-runner

   # Download and extract the official agent package (Use the exact URL from your GitHub screen)
   curl -o actions-runner-linux-x64-2.XXX.X.tar.gz -L https://github.com...
   tar xzf ./actions-runner-linux-x64-2.XXX.X.tar.gz

   # Register and bind the agent securely to your repository
   ./config.sh --url https://github.com... --token YOUR_DYNAMIC_TOKEN --labels net-control
   ```

6. **Install and enable the persistent background daemon (Service):**
   Type `exit` to leave the secure user session back to your administrator profile.
   ```bash
   # Exit to return to your sudo user context
   exit

   # Navigate directly to the installation folder using the dynamic home path of your custom runner user
   # Replace 'github-runner' with the name you chose in Step 1 if different
   cd ~github-runner/actions-runner

   # Provision and start the background service securely
   sudo ./svc.sh install github-runner
   sudo ./svc.sh start
   ```
---

### Option B: Standard Local Environment Setup

If you are just developing playbooks or running testing cycles directly on your local workstation without registering a GitHub Runner agent.

1. **Clone the repository and navigate to the folder:**
   ```bash
   git clone https://github.com/wirkentod/net-as-code.git
   cd net-as-code
   ```

2. **Prepare and update your variable secrets:**
   ```bash
   mv vars_secrets.yaml.example vars_secrets.yaml
   ```

3. **Initialize the local virtual environment and dependencies:**
   ```bash
   source setup.sh vars_secrets.yaml
   ```

4. **Execute your Playbook:**
   ```bash
   ansible-playbook site-playbook.yaml -i inventory.yaml -e @vars_secrets.yaml
   ```

## 📂 Project Structure

```text
net-as-code/
├── .github/
│   └── workflows/
│       └── netdevops.yml     # GitHub Actions pipeline (CI/CD)
├── inventory.yaml            # Inventory with defined network topology
├── site-playbook.yaml        # Main playbook (orchestrator)
├── ansible.cfg               # Local Ansible configuration
├── init-runner.sh            # Production host provisioning & security hardening script
├── setup.sh                  # Python virtualenv builder & dynamic Ansible Vault wrapper
└── vars_secrets.yaml         # ENCRYPTED file with Ansible Vault
```

### 🛠️ Key Components

* **`init-runner.sh`** : Provisions the system-level environment on your host controller.
* **`setup.sh`** : Automates application-level tasks.
* **`netdevops.yml`**: Automates linting tests and deployment tasks to network devices on every *push* or *Pull Request*.
* **`inventory.yaml`**: Contains hosts grouped by roles or locations, along with their connection parameters.
* **`site-playbook.yaml`**: The main entry point to run configurations across the infrastructure.
* **`vars_secrets.yaml`**: Protects sensitive credentials. It requires `--ask-vault-pass` or a secret key during pipeline execution to decrypt.