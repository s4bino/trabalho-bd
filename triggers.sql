-- TRIGGERS --
use mydb;

-- trigger de auditoria (UPDATE)
CREATE TABLE auditoriaNotaFinal (
idAuditoria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
CPFaluno CHAR(11) NOT NULL,
notaAnterior INT (3) NOT NULL,
notaNova INT(3) NOT NULL,
user VARCHAR(20) NOT NULL,
dataHora datetime NOT NULL
);

DELIMITER $$
CREATE TRIGGER after_Professor_update
AFTER UPDATE ON inscrito
FOR EACH ROW
BEGIN
	IF OLD.NotaFinal != NEW.NotaFinal THEN
    INSERT INTO auditoriaNotaFinal (CPFaluno, notaAnterior, notaNova, user, dataHora)
    VALUE (NEW.CPF, OLD.NotaFinal, NEW.NotaFinal, USER(), NOW());
    END IF;
END $$
DELIMITER ;

--  exemplo aplicando o trigger de auditoria

SELECT * FROM inscrito;

UPDATE inscrito
SET NotaFinal = 60
WHERE CPF = '06980759000' AND idTurma = 2;

SELECT * FROM inscrito;

SELECT * FROM auditoriaNotaFinal; 

-- ----------------------------------------------------------

-- Não é possível inserir um curso que contenha mais de 12 periodos (INSERT)

DELIMITER $$
CREATE TRIGGER before_curso_insert
BEFORE INSERT ON curso
FOR EACH ROW
BEGIN
	IF NEW.QtdPeriodos > 12 THEN
    SIGNAL SQLSTATE '45000' SET message_text = 'A quantidade máxima de períodos que um curso pode ter na UFLA é 12. Por favor, insira um curso com 12  ou menos periodos!';
    END IF;
END $$
DELIMITER ;

-- Teste do trigger, inserindo um curso com 13 periodos, para disparar o trigger

INSERT INTO curso (NomeCurso, Codigo, Modalidade, Periodo, QtdPeriodos, QtdVagas, NomeDept)
VALUE ('Engenharia de Automação', '7777', 'B', 'I', 13 , 40, 'Departamento de ciencias exatas');


-- ----------------------------------------------------------

-- TRIGGER de horarios diponiveis após uma turma excluir um determinado horário (DELETE)

CREATE TABLE HorariosDispo (
idHorario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
LocalHor VARCHAR(45) NOT NULL,
Dia VARCHAR(45) NOT NULL
);

DELIMITER $$
CREATE TRIGGER after_horario_delete 
AFTER DELETE ON horario
FOR EACH ROW
BEGIN
	INSERT INTO HorariosDispo (LocalHor, Dia)
    VALUE (OLD.Local, OLD.Dia);
END $$
DELIMITER ;

-- Testando trigger, deletando um horario para disparar o trigger e adicionar este horario deletado na tabela de horarios diponiveis 

SELECT * from horario;

DELETE FROM Horario WHERE Local = 'Pavilhão 6' AND Dia = 'Segunda Feira 10:00' AND idTurma = 1;

SELECT * from HorariosDispo;
