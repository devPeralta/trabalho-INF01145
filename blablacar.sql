CREATE TABLE usuarios
(
    id           SERIAL PRIMARY KEY,                 -- ID único e auto-incremental para cada usuário
    nome         VARCHAR(100)       NOT NULL,        -- Nome completo do usuário, não nulo
    email        VARCHAR(50) UNIQUE NOT NULL,        -- E-mail do usuário, único e não nulo
    telefone     VARCHAR(15),                        -- Telefone do usuário, opcional
    sobre        TEXT,                               -- Descrição sobre o usuário, opcional
    dataRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data e hora do registro, padrão é o momento atual
);

CREATE TABLE avaliacoes
(
    id           SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada avaliação
    mensagem     TEXT    NOT NULL, -- Mensagem da avaliação, não nula
    nota         INT CHECK (nota >= 1 AND nota <= 5), -- Nota da avaliação, entre 1 e 5
    data         TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora da avaliação, padrão é o momento atual
    avaliadorID INT NOT NULL, -- ID do usuário que fez a avaliação, não nulo
    avaliadoID  INT NOT NULL, -- ID do usuário que foi avaliado, não nulo
    FOREIGN KEY (avaliadorID) REFERENCES usuarios (id), -- Chave estrangeira para a tabela de usuários
    FOREIGN KEY (avaliadoID) REFERENCES usuarios (id) -- Chave estrangeira para a tabela de usuários
);

CREATE TABLE motoristas
(
    id      INT PRIMARY KEY REFERENCES usuarios (id), -- ID do usuário, chave primária e estrangeira
    preferenciaAnimais BOOLEAN NOT NULL, -- Preferência por animais, não nulo
    preferenciaCigarro BOOLEAN NOT NULL, -- Preferência por cigarro, não nulo
    preferenciaMusica BOOLEAN NOT NULL, -- Preferência por música, não nulo
    preferenciaConversa BOOLEAN NOT NULL,
    quantidadeCaronas INT NOT NULL -- Quantidade de caronas dadas pelo motorista, não nula
);

CREATE TABLE passageiros
(
    id INT PRIMARY KEY REFERENCES usuarios (id), -- ID do usuário, chave primária e estrangeira
    localizacaoAtual VARCHAR(100) NOT NULL -- Localização atual do passageiro, não nula
);

CREATE TABLE carros
(
                       placa VARCHAR(8) PRIMARY KEY, -- Placa do carro, chave primária (exemplo: ABC-1D23
                       modelo VARCHAR(20) NOT NULL, -- Modelo do carro, não nulo
                       marca VARCHAR(20) NOT NULL, -- Marca do carro, não nulo
                       ano INT CHECK (ano >= 1900 AND ano <= EXTRACT(YEAR FROM CURRENT_DATE)) -- Ano do carro, entre 1900 e o ano atual
);

CREATE TABLE rotas
(
    id        SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada rota
    origem    VARCHAR(100) NOT NULL, -- Local de origem da rota, não nulo
    destino   VARCHAR(100) NOT NULL, -- Local de destino da rota, não nulo
    distancia INT          NOT NULL -- Distância entre a origem e o destino, não nulo
);

CREATE TABLE viagens
(
    id      SERIAL PRIMARY KEY,    -- ID único e auto-incremental para cada viagem
    preco   INT          NOT NULL, -- Preço da viagem, não nulo
    data    TIMESTAMP    NOT NULL, -- Data e hora da viagem, não nulo
    horaSaida TIMESTAMP NOT NULL, -- Hora de saída da viagem, não nulo
    horaChegada TIMESTAMP NOT NULL -- Hora de chegada da viagem, não nulo
);

CREATE TABLE caronas
(
    id SERIAL PRIMARY KEY, -- ID único e auto-incremental para cada carona
    viagemID INT NOT NULL UNIQUE, -- ID da viagem associada, que deve ser único e refere-se a uma viagem existente
    status BOOLEAN NOT NULL, -- Indica se a carona já aconteceu ou não, não nulo
    reservaAutomatica BOOLEAN NOT NULL, -- Indica se a reserva é automática, não nulo
    assentosLivres INT NOT NULL, -- Quantidade de assentos livres na carona, não nulo
    FOREIGN KEY (viagemID) REFERENCES viagens (id) ON DELETE CASCADE -- Chave estrangeira para a tabela de viagens
);

CREATE TABLE onibus
(
    numeracao VARCHAR(20) PRIMARY KEY, -- Numeração do ônibus, chave primária
    empresa VARCHAR(100) NOT NULL, -- Empresa do ônibus, não nulo
    status BOOLEAN NOT NULL, -- Indica se a viagem de ônibus já aconteceu ou não, não nulo
    classe VARCHAR(50) NOT NULL, -- Classe do ônibus, não nulo
    wifi BOOLEAN NOT NULL, -- Indica se o ônibus tem Wi-Fi, não nulo
    banheiros BOOLEAN NOT NULL, -- Indica se o ônibus tem banheiros, não nulo
    arcondicionado BOOLEAN NOT NULL, -- Indica se o ônibus tem ar-condicionado, não nulo
    tomadas BOOLEAN NOT NULL, -- Indica se o ônibus tem tomadas, não nulo
    assentoreclinavel BOOLEAN NOT NULL, -- Indica se o ônibus tem assento reclinável, não nulo
    viagemID INT NOT NULL, -- ID da viagem associada, não nulo
    FOREIGN KEY (viagemID) REFERENCES viagens (id) -- Chave estrangeira para a tabela de viagens
);

CREATE TABLE conducao
(
    placa VARCHAR(8) NOT NULL, -- Placa do carro, chave estrangeira
    motoristaID INT NOT NULL, -- ID do motorista, chave estrangeira
    PRIMARY KEY (placa, motoristaID), -- Chave primária composta
    FOREIGN KEY (placa) REFERENCES carros (placa) ON DELETE CASCADE, -- Referência para a tabela de carros
    FOREIGN KEY (motoristaID) REFERENCES motoristas (id) ON DELETE CASCADE -- Referência para a tabela de motoristas
);

CREATE TABLE deslocamento
(
    viagemID INT NOT NULL,  -- ID da viagem, chave estrangeira
    rotaID INT NOT NULL,    -- ID da rota, chave estrangeira
    PRIMARY KEY (viagemID, rotaID), -- Chave primária composta
    FOREIGN KEY (viagemID) REFERENCES viagens (id) ON DELETE CASCADE, -- Referência para a tabela de viagens
    FOREIGN KEY (rotaID) REFERENCES rotas (id) ON DELETE CASCADE -- Referência para a tabela de rotas
);

CREATE TABLE reserva
(
    caronaID INT NOT NULL, -- ID da carona, chave estrangeira
    passageiroID INT NOT NULL, -- ID do passageiro, chave estrangeira
    quantidadePassageiros INT NOT NULL, -- Quantidade de passageiros na reserva de um único usuário, não nulo
    PRIMARY KEY (caronaID, passageiroID), -- Chave primária composta
    FOREIGN KEY (caronaID) REFERENCES caronas (id) ON DELETE CASCADE, -- Referência para a tabela de caronas
    FOREIGN KEY (passageiroID) REFERENCES passageiros (id) ON DELETE CASCADE -- Referência para a tabela de passageiros
);

CREATE TABLE oferta
(
    caronaID INT NOT NULL, -- ID da carona, chave estrangeira
    motoristaID INT NOT NULL, -- ID do motorista, chave estrangeira
    vai2Atras BOOLEAN NOT NULL, -- Indica se o motorista irá garantir um banco livre atrás, não nulo
    descricao TEXT, -- Descrição da carona, opcional
    PRIMARY KEY (caronaID, motoristaID), -- Chave primária composta
    FOREIGN KEY (caronaID) REFERENCES caronas (id) ON DELETE CASCADE, -- Referência para a tabela de caronas
    FOREIGN KEY (motoristaID) REFERENCES motoristas (id) ON DELETE CASCADE -- Referência para a tabela de motoristas
);

CREATE TABLE assento
(
    numeracaoOnibus VARCHAR(20) NOT NULL, -- Numeração do ônibus, não nulo
    passageiroID INT NOT NULL, -- ID do passageiro, não nulo
    numeroAssento INT NOT NULL, -- Número do assento no ônibus, não nulo
    PRIMARY KEY (numeracaoOnibus, passageiroID), -- Chave primária composta
    FOREIGN KEY (numeracaoOnibus) REFERENCES onibus (numeracao), -- Referência para a tabela de ônibus
    FOREIGN KEY (passageiroID) REFERENCES passageiros (id) -- Referência para a tabela de passageiros
);

------------------------------------------------------ INSERCOES -------------------------------------------------------

-- dados de usuarios (nome, email, telefone, sobre)
-- Inserir dados na tabela usuarios
INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('João Silva', 'joao.silva@gmail.com', '(82) 98552-6571', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Maria Oliveira', 'maria.oliveira@gmail.com', '(93) 98663-0067', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Carlos Souza', 'carlos.souza@gmail.com', '(66) 99636-7135', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Ana Lima', 'ana.lima@gmail.com', '(16) 98933-4989', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Pedro Santos', 'pedro.santos@gmail.com', '(27) 99809-1713', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Julia Costa', 'julia.costa@gmail.com', '(84) 97552-5639', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Marcos Pereira', 'marcos.pereira@gmail.com', '(91) 99502-4623', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Fernanda Almeida', 'fernanda.almeida@gmail.com', '(85) 97125-4254', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Ricardo Mendes', 'ricardo.mendes@gmail.com', '(95) 98532-6465', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Rocha', 'patricia.rocha@gmail.com', '(68) 97417-4659', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira@gmail.com', '(11) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima@gmail.com', '(21) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa@gmail.com', '(31) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida@gmail.com', '(41) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos@gmail.com', '(51) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira@gmail.com', '(61) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira@gmail.com', '(71) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza@gmail.com', '(81) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes@gmail.com', '(91) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha@gmail.com', '(92) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Thiago Martins', 'thiago.martins@gmail.com', '(93) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Camila Silva', 'camila.silva@gmail.com', '(94) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gustavo Lima', 'gustavo.lima@gmail.com', '(95) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Isabela Costa', 'isabela.costa@gmail.com', '(96) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Leonardo Almeida', 'leonardo.almeida@gmail.com', '(97) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Mariana Santos', 'mariana.santos@gmail.com', '(98) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Eduardo Oliveira', 'eduardo.oliveira@gmail.com', '(99) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Renata Pereira', 'renata.pereira@gmail.com', '(21) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Daniel Souza', 'daniel.souza@gmail.com', '(22) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Mendes', 'patricia.mendes@gmail.com', '(23) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira2@gmail.com', '(24) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima2@gmail.com', '(25) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa2@gmail.com', '(26) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida2@gmail.com', '(27) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos2@gmail.com', '(28) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira2@gmail.com', '(29) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira2@gmail.com', '(30) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza2@gmail.com', '(31) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes2@gmail.com', '(32) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha2@gmail.com', '(33) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Thiago Martins', 'thiago.martins2@gmail.com', '(34) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Camila Silva', 'camila.silva2@gmail.com', '(35) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gustavo Lima', 'gustavo.lima2@gmail.com', '(36) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Isabela Costa', 'isabela.costa2@gmail.com', '(37) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Leonardo Almeida', 'leonardo.almeida2@gmail.com', '(38) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Mariana Santos', 'mariana.santos2@gmail.com', '(39) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Eduardo Oliveira', 'eduardo.oliveira2@gmail.com', '(40) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Renata Pereira', 'renata.pereira2@gmail.com', '(41) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Daniel Souza', 'daniel.souza2@gmail.com', '(42) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Patricia Mendes', 'patricia.mendes2@gmail.com', '(43) 90123-4567', 'Passageira que gosta de música durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Lucas Ferreira', 'lucas.ferreira3@gmail.com', '(44) 91234-5678', 'Motorista experiente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Gabriela Lima', 'gabriela.lima3@gmail.com', '(45) 92345-6789', 'Passageira frequente');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rafael Costa', 'rafael.costa3@gmail.com', '(46) 93456-7890', 'Gosta de viagens longas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Beatriz Almeida', 'beatriz.almeida3@gmail.com', '(47) 94567-8901', 'Prefere viagens curtas');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Felipe Santos', 'felipe.santos3@gmail.com', '(48) 95678-9012', 'Motorista novato');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Larissa Oliveira', 'larissa.oliveira3@gmail.com', '(49) 96789-0123', 'Passageira ocasional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Bruno Pereira', 'bruno.pereira3@gmail.com', '(50) 97890-1234', 'Gosta de conversar durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Amanda Souza', 'amanda.souza3@gmail.com', '(51) 98901-2345', 'Prefere silêncio durante a viagem');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Rodrigo Mendes', 'rodrigo.mendes3@gmail.com', '(52) 99012-3456', 'Motorista com experiência internacional');

INSERT INTO usuarios (nome, email, telefone, sobre) VALUES ('Juliana Rocha', 'juliana.rocha3@gmail.com', '(53) 90123-4567', 'Passageira que gosta de música durante a viagem');

