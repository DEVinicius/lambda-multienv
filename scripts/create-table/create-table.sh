aws dynamodb delete-table \
    --no-cli-pager \
    --table-name commit_messages_qa \
    --endpoint-url http://localhost:4566

    

# Attribute Definitions -> Definição das chaves da tabela
# Key Schema -> Ao definir as chaves da aplicação devemos definir quais são os tipos de cada uma 
    # HASH - TEXTO | RANGE - NUMERO
# Provisioned Throughput -> Definição da capacidade do banco de dados
    # ReadCapacityUnits -> Numero de operações de leitura que poderão ser realizadas de forma simultanea
    # WriteCapacityUnits -> Numero de instancias que poderão escrever no banco de forma simultanea
aws dynamodb create-table \
    --table-name commit_messages_qa \
    --no-cli-pager \
    --region us-east-1 \
    --endpoint-url http://localhost:4566 \
    --attribute-definitions \
        AttributeName=id,AttributeType=S \
        AttributeName=commitMessage,AttributeType=S \
    --key-schema \
        AttributeName=id,KeyType=HASH \
        AttributeName=commitMessage,KeyType=RANGE \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 | tee logs.json

aws dynamodb scan \
    --no-cli-pager \
    --region us-east-1 \
    --table-name commit_messages_qa \
    --endpoint-url http://localhost:4566 


aws dynamodb list-tables \
    --no-cli-pager \
    --region us-east-1 \
    --endpoint http://localhost:4566