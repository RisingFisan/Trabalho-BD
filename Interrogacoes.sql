delimiter $$
CREATE PROCEDURE viagensPorDia()
BEGIN
    SELECT `data`, COUNT(id) AS viagensPorDia FROM Viagem
    GROUP BY `data`;
END
$$
-- Contabiliza o total de viagens realizadas por dia.

delimiter $$
CREATE PROCEDURE viagensPorCliente()
BEGIN
    SELECT Cliente.NIF, Passe.nome, count(VC.idViagem) AS totalViagens
    FROM ViagemCliente AS VC
    JOIN Cliente ON VC.NIFCliente = Cliente.NIF 
    LEFT JOIN Passe ON VC.NIFCliente = Passe.NIFCliente
    GROUP BY Cliente.NIF, Passe.nome
    ORDER BY totalViagens desc;
END $$
-- Contabiliza os clientes que realizaram mais viagens.

delimiter $$
CREATE PROCEDURE lucroPorPercurso()
BEGIN
    SELECT numeroPercurso, sum(VC.custoBilhete) AS lucroBilhetes FROM Viagem
    JOIN ViagemCliente AS VC ON Viagem.id = VC.idViagem
    GROUP BY Viagem.numeroPercurso
    ORDER BY numeroPercurso;
END
$$
-- Contabiliza o lucro obtido com a venda de bilhetes por percurso.

delimiter $$
CREATE PROCEDURE clientesPorViagem(IN numViagem int)
BEGIN
	SELECT Cliente.NIF, Passe.nome FROM ViagemCliente 
    JOIN Cliente on ViagemCliente.NIFCliente = Cliente.NIF
    LEFT JOIN Passe on Cliente.NIF = Passe.NIFCliente
    WHERE ViagemCliente.idViagem = numViagem;
END
$$

delimiter $$
CREATE PROCEDURE autocarrosQueViajaram(IN dia DATE)
BEGIN
	SELECT Autocarro.matricula FROM Autocarro
    JOIN Viagem on Viagem.matriculaAutocarro = Autocarro.matricula
    WHERE Viagem.data = dia;
END
$$