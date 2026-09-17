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

### Phase 1: Local Preparation & System Provisioning (As `ubuntu` User)
1. **Clone the Repository & Configure Initial Secrets**
   ```bash
   git clone https://github.com/wirkentod/net-as-code.git
   cd net-as-code
   
   # Generate your secrets file and apply credentials
   mv vars_secrets.yaml.example vars_secrets.yaml
   # Edit your real secrets inside vars_secrets.yaml first, then execute:
   ```

2. **Relocate Project & Install Base Core Dependencies**
   Migrate the repository to the global production hierarchy and install core system utilities:
   ```bash
   cd ..
   sudo mv net-as-code /opt/
   cd /opt/net-as-code
   
   # Synchronize packages and provision global runtimes
   sudo apt update && sudo apt install -y python3-venv python3-pip sshpass
   ```

3. **Initialize Isolated Security Hardening**
   ```bash
   chmod +x init-runner.sh
   sudo ./init-runner.sh github-runner
   ```
---

### Phase 2: Environment Initialization & Verification (As `github-runner` User)

4. **Establish Secure Session Context**
   Switch execution context:
   ```bash
   CURRENT_PATH=$PWD
   sudo -i -u github-runner
   cd "$CURRENT_PATH"
   ```

5. **Build Python Virtual Environment & Native Encryption**
   Deploy runtime virtual dependencies locally:
   ```bash
   source setup.sh vars_secrets.yaml
   ```

6. **Validate Playbook Execution State**
   ```bash
   source .venv/bin/activate
   ansible-playbook site-playbook.yaml -i inventory.yaml -e @vars_secrets.yaml
   ```
---

### Phase 3: CI/CD Runner Orchestration Service Setup

7. **Download & Provision GitHub Actions Agent Package**
   ```bash
   cd ~/
   mkdir actions-runner && cd actions-runner
   
   # Extract the architecture package and execute interactive self-registration
   curl -o actions-runner-linux-x64-2.XXX.X.tar.gz -L https://github.com...
   tar xzf ./actions-runner-linux-x64-2.XXX.X.tar.gz
   ./config.sh --url https://github.com... --token YOUR_DYNAMIC_TOKEN --labels net-control
   ```

8. **Register Background Daemon Processes Globally**
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
   chmod +x setup.sh
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