# Control Network as Code

This project explores network control as code.

Quick start

1. **Clone the repository and navigate to the directory:**

```bash
git clone https://github.com/wirkentod/net-as-code.git
cd net-as-code
```

2. **Run the setup script**
You need to grant execution permissions to the script before running it for the first time:

```bash
chmod +x setup.sh
./setup.sh
```

3. **Activate the environment**
Once the setup finishes successfully, activate your new Python virtual environment:
```bash
source .venv/bin/activate
```

4. **Run Playbook**

Run to control network topology:

```bash
ansible-playbook site-playbook.yaml -i inventory.yaml -e @vars_secrets.yaml
```

## 📁 Repository Structure
net-as-code/
├── .github/
│   └── workflows/
│       └── netdevops.yml      # Pipeline GitHub Actions (CI/CD).
├── inventory.yaml             # Inventory with defined topology.
├── site-playbook.yaml         # Mean playbook (orchestrator).
├── ansible.cfg                # Local Ansible configuration.
└── vars_secrets.yaml          # ENCRYPTED file with Ansible Vault
