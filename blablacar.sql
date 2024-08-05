CREATE TABLE usuarios (
                          id SERIAL PRIMARY KEY,        -- ID único e auto-incremental para cada usuário
                          nome VARCHAR(100) NOT NULL,   -- Nome completo do usuário, não nulo
                          email VARCHAR(50) UNIQUE NOT NULL, -- E-mail do usuário, único e não nulo
                          telefone VARCHAR(15),         -- Telefone do usuário, opcional
                          sobre TEXT,                   -- Descrição sobre o usuário, opcional
                          dataRegistro TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data e hora do registro, padrão é o momento atual
);

CREATE TABLE avaliacoes (
                                                      id SERIAL PRIMARY KEY,
                                                      mensagem TEXT NOT NULL,
                                                      nota INTEGER CHECK (nota >= 1 AND nota <= 10),
                                                      data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                      avaliador_id INTEGER NOT NULL,
                                                      avaliado_id INTEGER NOT NULL,
                                                      FOREIGN KEY (avaliador_id) REFERENCES usuarios(id),
                                                      FOREIGN KEY (avaliado_id) REFERENCES usuarios(id)
);

