FROM frappe/erpnext:v16.13.1

USER frappe

WORKDIR /home/frappe/frappe-bench/apps

# Clone apps with git directly (skips auto pip install)
RUN git clone https://github.com/erpchampions/uganda_compliance --branch version-15 --depth 1

RUN git clone https://github.com/DeliveryDevs-ERP/Cargo-Management --branch main --depth 1

# Fix uganda_compliance dependencies before installing
RUN sed -i 's/pillow==10.2.0/Pillow>=10.3.0/' uganda_compliance/pyproject.toml && \
    sed -i 's/numpy==2.2.4/numpy>=1.26.0/' uganda_compliance/pyproject.toml

# Fix cargo_management hooks - note capital C and dash in folder name
RUN sed -i 's/^before_install/#before_install/' Cargo-Management/cargo_management/hooks.py && \
    sed -i 's/^after_install/#after_install/' Cargo-Management/cargo_management/hooks.py

WORKDIR /home/frappe/frappe-bench

# Install apps
RUN /home/frappe/frappe-bench/env/bin/pip install -e apps/uganda_compliance

RUN /home/frappe/frappe-bench/env/bin/pip install -e apps/Cargo-Management

# Restore Frappe's required versions
RUN /home/frappe/frappe-bench/env/bin/pip install \
    "cryptography~=46.0.3" \
    "pyOpenSSL~=26.0.0"
