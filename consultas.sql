CREATE VIEW usuario_avaliacoes AS
SELECT
    u.nome AS nome_usuario,
    a.mensagem AS mensagem_avaliacao,
    a.nota AS nota_avaliacao,
    a.data AS data_avaliacao
FROM
    usuarios u
        JOIN
    avaliacoes a ON u.id = a.avaliadoID;

drop view if exists usuario_avaliacoes;

CREATE VIEW viagem_deslocamentos AS
SELECT
    v.id AS viagemID,
    d.rotaID AS rotaID,
    v.data AS data_viagem,
    r.destino AS destino
FROM
    viagens v
        JOIN
    deslocamentos d ON v.id = d.viagemID
        JOIN
    rotas r ON d.rotaID = r.id;