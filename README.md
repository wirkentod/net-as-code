# Control Network as Code

This project explores network control as code.

Quick start

1. **Clone the repository and navigate to the directory:**

```bash
git clone https://github.com/wirkentod/net-as-code.git
cd net-as-code
```

2. **Update var secrets**
You need to update the password secrets according to the infrastructure topology:
```bash
mv vars_secrets.yaml.example vars_secrets.yaml
```

3. **Run the setup script**
You need to grant execution permissions to the script before running it for the first time:

```bash
chmod +x setup.sh
./setup.sh vars_secrets.yaml
```

4. **Activate the environment**
Once the setup finishes successfully, activate your new Python virtual environment:
```bash
source .venv/bin/activate
```

5. **Run Playbook**

Run to control network topology:

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
└── vars_secrets.yaml         # ENCRYPTED file with Ansible Vault
```

### 🛠️ Key Components

* **`netdevops.yml`**: Automates linting tests and deployment tasks to network devices on every *push* or *Pull Request*.
* **`inventory.yaml`**: Contains hosts grouped by roles or locations, along with their connection parameters.
* **`site-playbook.yaml`**: The main entry point to run configurations across the infrastructure.
* **`vars_secrets.yaml`**: Protects sensitive credentials. It requires `--ask-vault-pass` or a secret key during pipeline execution to decrypt.