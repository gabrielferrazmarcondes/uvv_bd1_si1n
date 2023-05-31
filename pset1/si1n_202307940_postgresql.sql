--SE O BANCO DE DADOS UVV JA EXISTIR, FAZER A EXCLUSAO
DROP DATABASE IF EXISTS uvv;
--EXCLUIR USUARIO CASO EXISTA UM
DROP USER IF EXISTS gabrielferraz;
--CRIAR USUARIO ADMIN DO BANCO DE DADOS
CREATE USER gabrielferraz WITH
CREATEDB
CREATEROLE
INHERIT
ENCRYPTED PASSWORD 'ferraz';
--CRIAR BANCO DE DADOS UVV
CREATE DATABASE uvv WITH 
TEMPLATE = 'template0'
ENCODING = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = 'true'
OWNER = 'gabrielferraz';
--SE LIGAR COM O BANCO DE DADOS 
\c "dbname=uvv user=gabrielferraz password=ferraz"
SET ROLE gabrielferraz;
--CRIAR SCHEMA
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION gabrielferraz;
--PADRAO DEFINIDO PARA AS LOJAS
SET SEARCH_PATH TO lojas, "$user", public;
--ALTERAR USUARIO
ALTER USER gabrielferraz
SET SEARCH_PATH TO Lojas, "$user", public;
--CRIAR TABELA CLIENTE
CREATE TABLE cliente (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR,
                CONSTRAINT cliente_pk PRIMARY KEY (cliente_id)
);--COMENTARIOS SOBRE A TABELA CLIENTE
COMMENT ON COLUMN cliente.cliente_id IS 'Identificação do cliente.';
COMMENT ON COLUMN cliente.email IS 'Email do cliente.
';
COMMENT ON COLUMN cliente.nome IS 'Nome do cliente.';
COMMENT ON COLUMN cliente.telefone1 IS 'Contato 1 do cliente.';
COMMENT ON COLUMN cliente.telefone2 IS 'Contato 2 do cliente.';
COMMENT ON COLUMN cliente.telefone3 IS 'Contato 3 do cliente.';

--CRIAR TABELA LOJA
CREATE TABLE loja (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                logo_ultima_atualizacao DATE,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude VARCHAR,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                CONSTRAINT loja_pk PRIMARY KEY (loja_id)
--COMENTARIOS SOBRE A TABELA LOJA
);
COMMENT ON COLUMN loja.loja_id IS 'Identificação da loja.';
COMMENT ON COLUMN loja.nome IS 'Nome da loja.';
COMMENT ON COLUMN loja.logo_ultima_atualizacao IS 'Última atualização da logo da loja.';
COMMENT ON COLUMN loja.endereco_web IS 'Site da loja.';
COMMENT ON COLUMN loja.endereco_fisico IS 'Endereço físico da loja.';
COMMENT ON COLUMN loja.latitude IS 'Latitude onde a loja está localizada.';
COMMENT ON COLUMN loja.longitude IS 'Longitude onde a loja está localizada.';
COMMENT ON COLUMN loja.logo IS 'Logo da loja.';
COMMENT ON COLUMN loja.logo_mime_type IS 'Armazenamento para dados ocultos.';
COMMENT ON COLUMN loja.logo_arquivo IS 'Aruqivo da logo.';
COMMENT ON COLUMN loja.logo_charset IS 'Armazena símbolos e/ou caracteres especiais. ';

--CRIAR TABELA PEDIDO
CREATE TABLE pedido (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_pk PRIMARY KEY (pedido_id),
                
                --CRIAR CHECK DO STATUS DO PEDIDO
                
                CONSTRAINT ck_pedido_status
                CHECK (status IN ('CANCELADO','COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO')));

               --COMENTARIOS SOBRE A TABELA PEDIDO                

COMMENT ON COLUMN pedido.pedido_id IS 'Identificação dos pedidos dos clientes.';
COMMENT ON COLUMN pedido.data_hora IS 'Data e hora em que o pedido foi realizado.';
COMMENT ON COLUMN pedido.cliente_id IS 'Identificação do cliente.';
COMMENT ON COLUMN pedido.status IS 'Status do pedido.';
COMMENT ON COLUMN pedido.loja_id IS 'Identificação da loja.';

--CRIAR TABELA PRODUTO
CREATE TABLE produto (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_pk PRIMARY KEY (produto_id)
--COMENTARIOS SOBRE A TABELA PRODUTO                
);
COMMENT ON COLUMN produto.nome IS 'Nome do produto.';
COMMENT ON COLUMN produto.preco_unitario IS 'Valor do produto.';
COMMENT ON COLUMN produto.detalhes IS 'Descrição do produto.';
COMMENT ON COLUMN produto.imagem IS 'Foto do produto.';
COMMENT ON COLUMN produto.imagem_mime_type IS 'Armazenamento para dados ocultos do produto.';
COMMENT ON COLUMN produto.imagem_arquivo IS 'Arquivo da imagem do produto.';
COMMENT ON COLUMN produto.imagem_charset IS 'Armazena símbolos e/ou caracteres especiais do produto.';
COMMENT ON COLUMN produto.imagem_ultima_atualizacao IS 'Última atualização da imagem do produto.';

--CIRAR TABELA ENVIO
CREATE TABLE envio (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_pk PRIMARY KEY (envio_id),
                --CRIAR CHECK DO STATUS DO ENVIO
                CONSTRAINT ck_envio_status
                CHECK (status IN ('CRIADO','ENVIADO','TRANSITO','ENTREGUE')));
                
--COMENTARIOS SOBRE A TABELA ENVIO                

COMMENT ON COLUMN envio.envio_id IS 'Identificação do envio.';
COMMENT ON COLUMN envio.loja_id IS 'Identificação da loja.';
COMMENT ON COLUMN envio.cliente_id IS 'Identificação do cliente.';
COMMENT ON COLUMN envio.endereco_entrega IS 'Endereço para entrega do produto.';
COMMENT ON COLUMN envio.status IS 'Status do envio.';

--CRIAR TABELA ESTOQUE
CREATE TABLE estoque (
                estoque_id NUMERIC NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_pk PRIMARY KEY (estoque_id)
--COMENTARIOS SOBRE A TABELA ESTOQUE                
);
COMMENT ON COLUMN estoque.loja_id IS 'Identificação da loja.';
COMMENT ON COLUMN estoque.produto_id IS 'Identificação do produto.';
COMMENT ON COLUMN estoque.quantidade IS 'Quantidade de unidades do produto.';

--CRIAR TABELA PEDIDO_ITEM
CREATE TABLE pedido_Item (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pedidos_itens PRIMARY KEY (pedido_id, produto_id)
--COMENTARIOS SOBRE A TABELA PEDIDO_ITEM                
);
COMMENT ON TABLE pedido_Item IS 'Tabela sobre os pedidos dos clientes.';
COMMENT ON COLUMN pedido_Item.pedido_id IS 'Identificação dos pedidos dos clientes.';
COMMENT ON COLUMN pedido_Item.quantidade IS 'Quantidade de pedidos e itens.';
COMMENT ON COLUMN pedido_Item.preco_unitario IS 'Valor dos pedidos e itens.';
COMMENT ON COLUMN pedido_Item.numero_da_linha IS 'Linha onde o produto está presente.';
COMMENT ON COLUMN pedido_Item.envio_id IS 'Identificação do envio.';

--RELACAO DA TABELA PEDIDO COM A TABELA CLIENTE
ALTER TABLE pedido ADD CONSTRAINT cliente_pedido_fk
FOREIGN KEY (cliente_id)
REFERENCES cliente (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA ENVIO COM A TABELA CLIENTE
ALTER TABLE envio ADD CONSTRAINT cliente_envio_fk
FOREIGN KEY (cliente_id)
REFERENCES cliente (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA PEDIDO COM A TABELA LOJA
ALTER TABLE pedido ADD CONSTRAINT loja_pedido_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA ENVIO COM A TABELA LOJA
ALTER TABLE envio ADD CONSTRAINT loja_envio_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA ESTOQUE COM A TABELA LOJA
ALTER TABLE estoque ADD CONSTRAINT loja_estoque_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA PEDIDO ITEM COM A TABELA PEDIDO 
ALTER TABLE pedido_Item ADD CONSTRAINT pedido_pedido_item_fk
FOREIGN KEY (pedido_id)
REFERENCES pedido (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA ESTOQUE COM A TABELA PRODUTO
ALTER TABLE estoque ADD CONSTRAINT produto_estoque_fk
FOREIGN KEY (produto_id)
REFERENCES produto (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA PEDIDO_ITEM COM A TABELA PRODUTO
ALTER TABLE pedido_Item ADD CONSTRAINT produto_pedido_item_fk
FOREIGN KEY (produto_id)
REFERENCES produto (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--RELACAO DA TABELA PEDIDO_ITEM COM A TABELA ENVIO
ALTER TABLE pedido_Item ADD CONSTRAINT envio_pedido_item_fk
FOREIGN KEY (envio_id)
REFERENCES envio (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
