-- STORE PROCEDURES

use mydb;

-- aluno aleatorio de uma disciplina
DELIMITER //
drop procedure if exists randomStudent //
CREATE PROCEDURE randomStudent (IN pDisciplina VARCHAR(80), OUT randomStudentName VARCHAR (80))
BEGIN
	SELECT NomeSocial INTO randomStudentName 
    FROM pessoa P, aluno A, curso C, possui PO, disciplina D
    WHERE P.CPF = A.CPF AND A.Curso_Codigo = C.Codigo AND C.Codigo = PO.CodigoCurso AND PO.CodigoDscp = D.Codigo ORDER BY RAND() 
    LIMIT 1;
END //
DELIMITER ;

-- Testando store procedure

CALL randomStudent ('Calculo I', @NomeAluno);
SELECT @NomeAluno AS alunoAleatorio;

-- ----------------------------------------------------------

/*
sistema de balanceamento de notas. Ex: Um professor viu que aplicou uma prova complexa demais
e decidiu aumentar as notas de forma que ficasse justo para todos. Sendo assim, ele viu que era 
melhor aumentar a nota dos que tiraram menos de 30% em 25% há mais da nota tirada e dos que tiraram
entre 31% e 59%, ele aumentou em 10%. Com o fim de equilibrar as notas. 
*/

DELIMITER //
drop procedure if exists pontoExtra //
CREATE PROCEDURE pontoExtra (IN pNomeDscp VARCHAR(80))
BEGIN
	DECLARE done INT DEFAULT FALSE;

    DECLARE vCPF CHAR(11);
    DECLARE vNomeSocial VARCHAR(80);
	DECLARE vNotaFinal INT;
     
	DECLARE extraPoint CURSOR FOR 
		SELECT I.CPF, P.NomeSocial, I.NotaFinal 
        FROM pessoa P, aluno A, inscrito I, turma T, disciplina D
		WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND I.idTurma = T.idTurma AND T.CodigoDscp = D.Codigo AND D.NomeDscp = pNomeDscp;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN extraPoint;
    
    read_loop: LOOP
		FETCH extraPoint INTO vCPF, vNomeSocial, vNotaFinal;
        
        IF done THEN
			LEAVE read_loop;
		END IF;
    
		IF vNotaFinal > 30 AND vNotaFinal < 60 THEN
			UPDATE inscrito SET NotaFinal = NotaFinal * 1.1 WHERE CPF = vCPF;
		ELSEIF vNotaFinal > 0 AND vNotaFinal <= 30 THEN
			UPDATE inscrito SET NotaFinal = NotaFinal * 1.25 WHERE CPF = vCPF;
		END IF;
        
    END LOOP;
    
    CLOSE extraPoint;

END //
DELIMITER ;

/*
Testando o store procedure, ao chamar o procedimento, ele balanceará as notas que foram abaixo da 
média em uma disciplina específica 
*/

SELECT I.CPF, NomeSocial, NotaFinal FROM pessoa P, aluno A, inscrito I, turma T, disciplina D
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND I.idTurma = T.idTurma AND T.CodigoDscp = D.Codigo AND D.NomeDscp = 'Arquitetura de computadores';

CALL pontoExtra ('Arquitetura de computadores');

SELECT I.CPF, NomeSocial, NotaFinal FROM pessoa P, aluno A, inscrito I, turma T, disciplina D
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND I.idTurma = T.idTurma AND T.CodigoDscp = D.Codigo AND D.NomeDscp = 'Arquitetura de computadores';


-- ----------------------------------------------------------

/*
Capitaliza todos os nomes na coluna `NomeSocial` na tabela 'pessoa'.
*/

DELIMITER //
drop procedure if exists lowerNames //
CREATE PROCEDURE lowerNames ()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    
	DECLARE vCPF CHAR (11);
    DECLARE vNomeSocial VARCHAR(80);
	
    DECLARE i INT;
	DECLARE c, sc CHAR (1);
	DECLARE outstr VARCHAR(1000);
    
	DECLARE lowering CURSOR FOR 
		SELECT CPF, NomeSocial 
        FROM pessoa;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN lowering;

    read_loop: LOOP
		FETCH lowering INTO vCPF, vNomeSocial;
        
        IF done THEN
			LEAVE read_loop;
		END IF;
		
		SET i = 1;
        SET outstr = vNomeSocial;
        WHILE i<= CHAR_LENGTH(vNomeSocial) DO
			SET c = SUBSTRING(vNomeSocial, i, 1);
            SET sc = CASE WHEN i = 1 THEN ' '
					 ELSE SUBSTRING(vNomeSocial, i - 1, 1)
                     END;
			IF sc IN (' ') THEN 
				SET outstr = INSERT(outstr, i, 1, UPPER(c));
			END IF;
            SET i = i+1;
		END WHILE;
        SET vNomeSocial = outstr;
        
        UPDATE pessoa SET NomeSocial = vNomeSocial WHERE CPF = vCPF;
        
    END LOOP;
    
    CLOSE lowering;

END //
DELIMITER ;

-- Testando o store procedure, capitalizando o nome da pessoa 'manoel gomes'.

SELECT NomeSocial FROM pessoa WHERE NomeSocial = 'manoel gomes';

INSERT INTO pessoa
VALUE ('12345678911', 'manoel gomes', 'M', '1969-12-2', 'MA', 'Balsas', 'Centro', 'Rua dos Pássaros', '13', 'Casa 13A'); 
VALUE ('12345678911', 'manoel gomes', 'M', '1969-12-2', 'MA', 'Balsas', 'Centro', 'Rua dos Pássaros', '13', 'Casa 13A'); 

CALL lowerNames();

SELECT NomeSocial FROM pessoa;
