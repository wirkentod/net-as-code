# Control Network as Code

This project explore the control of a network as code.

Quick start

1. **Clone the repository and navigate to the directory:**

```bash
git clone https://github.com/wirkentod/net-as-code.git
cd net-as-code
```

2. **Create a virtual environment and install dependencies:**

```bash
# On macOS/Linux:
python -m venv .venv
source .venv/bin/activate

# On Windows (PowerShell):
.venv\Scripts\activate

# Install requirements
pip install -r requirements.txt
```

## 📊 Command-Line Interface (CLI) Usage
3. Run the CLI:

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
