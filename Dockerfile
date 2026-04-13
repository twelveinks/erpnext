FROM frappe/erpnext:v16.13.1

USER frappe

WORKDIR /home/frappe/frappe-bench

# Fix hooks to avoid missing module errors
RUN bench get-app https://github.com/erpchampions/uganda_compliance --branch version-15 && \
    bench get-app https://github.com/DeliveryDevs-ERP/Cargo-Management --branch main && \
    sed -i 's/pillow==10.2.0/Pillow>=10.3.0/' apps/uganda_compliance/pyproject.toml && \
    sed -i 's/numpy==2.2.4/numpy>=1.26.0/' apps/uganda_compliance/pyproject.toml && \
    sed -i 's/^before_install/#before_install/' apps/cargo_management/cargo_management/hooks.py && \
    sed -i 's/^after_install/#after_install/' apps/cargo_management/cargo_management/hooks.py && \
    /home/frappe/frappe-bench/env/bin/pip install -e apps/uganda_compliance && \
    /home/frappe/frappe-bench/env/bin/pip install -e apps/cargo_management && \
    /home/frappe/frappe-bench/env/bin/pip install "cryptography~=46.0.3" "pyOpenSSL~=26.0.0"
