-- Retorna nome da disciplina e código da turma que a professora "Lisa Lisa" leciona.
SELECT NomeDscp, T.Codigo FROM disciplina D, pessoa N, professor P, turma T , leciona L 
WHERE N.NomeSocial = 'Lisa Lisa' AND N.CPF = P.CPF AND  P.CPF = L.CPF AND T.idTurma = L.idTurma AND T.CodigoDscp = D.Codigo;

-- Em que departamento cada professor trabalha.
SELECT DISTINCT NomeSocial, Nome FROM departamento D, curso C, possui P, disciplina DI, turma T, leciona L, professor PR, pessoa PE
WHERE D.Nome = C.NomeDept AND C.Codigo = P.CodigoCurso AND P.CodigoDscp = DI.Codigo 
AND DI.Codigo = T.CodigoDscp AND T.IdTurma = L.idTurma AND L.CPF = PR.CPF AND PR.CPF = PE.CPF;

-- quantas turmas cada disciplina tem.
SELECT NomeDscp, COUNT(*) AS qntdTurmas FROM turma T, disciplina D 
WHERE T.CodigoDscp = D.Codigo GROUP BY NomeDscp;

-- Alunos com CRA maior que 60,0
SELECT NomeSocial, AVG(NotaFinal) AS CRA FROM pessoa P, aluno A, inscrito I 
WHERE P.CPF = A.CPF AND A.CPF = I.CPF GROUP BY NomeSocial HAVING CRA >= 60;

-- Alunos que possuem nome que comece com a letra 'J'
SELECT NomeSocial FROM pessoa NATURAL JOIN aluno WHERE NomeSocial LIKE 'J%';

-- Professores que não possuem complemento 
SELECT NomeSocial FROM pessoa NATURAL JOIN professor WHERE Complemento IS NULL;

-- Alunos de Fisica que tem a nota maior que algum aluno de Matematica.
SELECT NomeSocial, NotaFinal FROM pessoa P, aluno A, curso C, inscrito I 
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND A.Curso_Codigo = C.Codigo AND C.NomeCurso = 'Fisica' AND I.NotaFinal > SOME 
(SELECT NotaFinal FROM pessoa P, aluno A, curso C, inscrito I 
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND A.Curso_Codigo = C.Codigo AND C.NomeCurso = 'Matematica');

-- Alunos de Fisica que tem a nota maior que todos os alunos de Matematica.
SELECT NomeSocial, NotaFinal FROM pessoa P, aluno A, curso C, inscrito I 
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND A.Curso_Codigo = C.Codigo AND C.NomeCurso = 'Fisica' AND I.NotaFinal > ALL 
(SELECT NotaFinal FROM pessoa P, aluno A, curso C, inscrito I 
WHERE P.CPF = A.CPF AND A.CPF = I.CPF AND A.Curso_Codigo = C.Codigo AND C.NomeCurso = 'Matematica');

-- Disciplinas que cada curso tem.
SELECT NomeCurso, NomeDscp FROM curso C, possui P, disciplina D 
WHERE C.Codigo = P.CodigoCurso AND P.CodigoDscp = D.Codigo;

-- Alunos de cada curso e datas de matricul.a
SELECT NomeCurso, NomeSocial, DataMatricula FROM  pessoa P, aluno A, curso C
WHERE P.CPF = A.CPF AND A.Curso_Codigo = C.codigo ;

-- Alunos que se matricularam entre 2019 e 2020
SELECT NomeSocial, DataMatricula FROM pessoa P, aluno A
WHERE P.CPF = A.CPF AND (DataMatricula BETWEEN '2019-01-01' AND '2020-01-01');

-- se tiber turma na terça, retorne quais são essas turmas.
SELECT T.idTurma, Codigo FROM turma T, horario H
WHERE T.idturma = H.idTurma AND H.Dia LIKE 'Terça%' AND EXISTS 
(SELECT * FROM horario
WHERE Dia LIKE 'Terça%');
