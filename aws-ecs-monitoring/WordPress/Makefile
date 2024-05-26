# 
# 
# 

.PHONY: init
init:
	terraform init

.PHONY: deploy
deploy:
	cd src && zip -r ../out/python.zip index.py && cd .. && \
		terraform validate && \
		terraform fmt && \
        terraform apply
