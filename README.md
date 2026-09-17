# Control Network as Code

This project explores network control as code.

---


## 🚀 Deployment Modes

Choose the setup path that best fits your active target environment:

| Deployment Path | Target Use Case |
| :--- | :--- |
| **Option A: Production Host** | Production controllers and orchestrators, persistent background CI/CD runner. |
| **Option B: Local Testing Sandbox** | Local workstations, quick playbook development, and testing. |

---

<details>
<summary>📋 <b>Click to expand — Option A: Secure Production Host Provisioning (Recommended)</b></summary>

### Step-by-Step Production Setup

Follow this sequence using your custom application user.

1. **Clone the repository and run the host initialization script:**
   The script dynamically registers the custom application user.
   ```bash
   git clone https://github.com/wirkentod/net-as-code.git
   cd net-as-code
   chmod +x init-runner.sh
   sudo ./init-runner.sh github-runner
   ```

2. **Switch contexts to your secure user and navigate to the project directory dynamically:**
   ```bash
   CURRENT_PATH=$PWD
   sudo -i -u github-runner cd "$CURRENT_PATH"
   ```

3. **Initialize credentials and activate the secure Python environment:**
   Encrypt your secrets file natively via Ansible Vault:
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
   Ensure you assign the mandatory label `net-control`:
   ```bash
   mkdir ~/actions-runner && cd ~/actions-runner
   # Extract and download the official agent package (Use your unique URL/Token from GitHub)
   curl -o actions-runner-linux-x64-2.XXX.X.tar.gz -L https://github.com...
   tar xzf ./actions-runner-linux-x64-2.XXX.X.tar.gz
   ./config.sh --url https://github.com... --token YOUR_DYNAMIC_TOKEN --labels net-control
   ```

6. **Install and enable the service:**
   ```bash
   exit
   # Install the service
   sudo -i
   cd ~github-runner/actions-runner
   sudo ./svc.sh install github-runner
   sudo ./svc.sh start
   ```
</details>

<details>
<summary>💻 <b>Click to expand — Option B: Standard Local Environment Setup</b></summary>

### Quick Local Workstation Configuration

If you are just developing playbooks or running testing cycles directly on your local machine.

1. **Clone the repository and navigate to the folder:**
   ```bash
   git clone https://github.com/wirkentod/net-as-code.git
   cd net-as-code
   ```

2. **Prepare and update your variable secrets:**
   ```bash
   mv vars_secrets.yaml.example vars_secrets.yaml
   # Edit your real secrets inside vars_secrets.yaml first, then execute:
   ```

3. **Initialize the local virtual environment and dependencies:**
   ```bash
   source setup.sh vars_secrets.yaml
   ```

4. **Execute your Playbook:**
   ```bash
   ansible-playbook site-playbook.yaml -i inventory.yaml -e @vars_secrets.yaml
   ```
</details>

---

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