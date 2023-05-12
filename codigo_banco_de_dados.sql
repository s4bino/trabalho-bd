-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pessoa` (
  `CPF` CHAR(11) NOT NULL,
  `NomeSocial` VARCHAR(80) NOT NULL,
  `Sexo` CHAR(1) NOT NULL,
  `Nascimento` DATE NOT NULL,
  `Estado` CHAR(2) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Bairro` VARCHAR(45) NOT NULL,
  `Logradouro` VARCHAR(45) NOT NULL,
  `Numero` VARCHAR(45) NOT NULL,
  `Complemento` VARCHAR(45) NULL,
  PRIMARY KEY (`CPF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Telefone` (
  `Telefone` VARCHAR(11) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  INDEX `fk_Telefone_Pessoa_idx` (`CPF` ASC) VISIBLE,
  PRIMARY KEY (`Telefone`, `CPF`),
  CONSTRAINT `fk_Telefone_Pessoa`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Professor` (
  `Registro` CHAR(9) NOT NULL,
  `Email` VARCHAR(256) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  PRIMARY KEY (`CPF`),
  INDEX `fk_Professor_Pessoa1_idx` (`CPF` ASC) VISIBLE,
  UNIQUE INDEX `Registro_UNIQUE` (`Registro` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_Professor_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Departamento` (
  `Nome` VARCHAR(80) NOT NULL,
  `UnidadeAc` VARCHAR(80) NOT NULL,
  `Telefone` VARCHAR(11) NULL,
  `Estado` CHAR(2) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Bairro` VARCHAR(45) NOT NULL,
  `Logradouro` VARCHAR(45) NOT NULL,
  `Numero` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Curso` (
  `NomeCurso` VARCHAR(80) NOT NULL,
  `Codigo` CHAR(5) NOT NULL,
  `Modalidade` CHAR(1) NOT NULL,
  `Periodo` CHAR(1) NOT NULL,
  `QtdPeriodos` INT(2) NOT NULL,
  `QtdVagas` INT(2) NOT NULL,
  `NomeDept` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`Codigo`),
  INDEX `fk_Curso_Departamento1_idx` (`NomeDept` ASC) VISIBLE,
  CONSTRAINT `fk_Curso_Departamento1`
    FOREIGN KEY (`NomeDept`)
    REFERENCES `mydb`.`Departamento` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Aluno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Aluno` (
  `Matricula` CHAR(9) NOT NULL,
  `Email` VARCHAR(256) NOT NULL,
  `DataAdmissao` DATE NOT NULL,
  `PeriodoInicial` CHAR(5) NOT NULL,
  `DataMatricula` DATE NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `Curso_Codigo` CHAR(5) NOT NULL,
  INDEX `fk_Aluno_Pessoa1_idx` (`CPF` ASC) VISIBLE,
  UNIQUE INDEX `Matricula_UNIQUE` (`Matricula` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  INDEX `fk_Aluno_Curso1_idx` (`Curso_Codigo` ASC) VISIBLE,
  PRIMARY KEY (`CPF`),
  CONSTRAINT `fk_Aluno_Pessoa1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Pessoa` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_Curso1`
    FOREIGN KEY (`Curso_Codigo`)
    REFERENCES `mydb`.`Curso` (`Codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AreaDeInteresse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AreaDeInteresse` (
  `AreaInteresse` VARCHAR(80) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  PRIMARY KEY (`AreaInteresse`, `CPF`),
  INDEX `fk_AreaDeInteresse_Professor1_idx` (`CPF` ASC) VISIBLE,
  CONSTRAINT `fk_AreaDeInteresse_Professor1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Professor` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Disciplina` (
  `Codigo` CHAR(5) NOT NULL,
  `NomeDscp` VARCHAR(80) NOT NULL,
  `HrPratica` INT(3) NOT NULL,
  `HrTeoricas` INT(3) NOT NULL,
  `Creditos` INT(2) NOT NULL,
  PRIMARY KEY (`Codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Possui`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Possui` (
  `CodigoDscp` CHAR(5) NOT NULL,
  `CodigoCurso` CHAR(5) NOT NULL,
  PRIMARY KEY (`CodigoDscp`, `CodigoCurso`),
  INDEX `fk_Disciplina_has_Curso_Curso1_idx` (`CodigoCurso` ASC) VISIBLE,
  INDEX `fk_Disciplina_has_Curso_Disciplina1_idx` (`CodigoDscp` ASC) VISIBLE,
  CONSTRAINT `fk_Disciplina_has_Curso_Disciplina1`
    FOREIGN KEY (`CodigoDscp`)
    REFERENCES `mydb`.`Disciplina` (`Codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disciplina_has_Curso_Curso1`
    FOREIGN KEY (`CodigoCurso`)
    REFERENCES `mydb`.`Curso` (`Codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Turma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Turma` (
  `idTurma` INT NOT NULL,
  `Semestre` CHAR(5) NOT NULL,
  `Codigo` CHAR(6) NOT NULL,
  `CodigoDscp` CHAR(5) NOT NULL,
  PRIMARY KEY (`idTurma`),
  UNIQUE INDEX `Semestre_UNIQUE` (`Semestre` ASC, `Codigo` ASC, `CodigoDscp` ASC) VISIBLE,
  INDEX `fk_Turma_Disciplina1_idx` (`CodigoDscp` ASC) VISIBLE,
  CONSTRAINT `fk_Turma_Disciplina1`
    FOREIGN KEY (`CodigoDscp`)
    REFERENCES `mydb`.`Disciplina` (`Codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Horario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Horario` (
  `Local` VARCHAR(45) NOT NULL,
  `Dia` VARCHAR(45) NOT NULL,
  `idTurma` INT NOT NULL,
  PRIMARY KEY (`idTurma`, `Dia`, `Local`),
  CONSTRAINT `fk_Horario_Turma1`
    FOREIGN KEY (`idTurma`)
    REFERENCES `mydb`.`Turma` (`idTurma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Leciona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Leciona` (
  `CPF` CHAR(11) NOT NULL,
  `idTurma` INT NOT NULL,
  PRIMARY KEY (`CPF`, `idTurma`),
  INDEX `fk_Professor_has_Turma_Turma1_idx` (`idTurma` ASC) VISIBLE,
  INDEX `fk_Professor_has_Turma_Professor1_idx` (`CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Professor_has_Turma_Professor1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Professor` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professor_has_Turma_Turma1`
    FOREIGN KEY (`idTurma`)
    REFERENCES `mydb`.`Turma` (`idTurma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inscrito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Inscrito` (
  `CPF` CHAR(11) NOT NULL,
  `idTurma` INT NOT NULL,
  `NotaFinal` INT(3) NOT NULL,
  PRIMARY KEY (`CPF`, `idTurma`),
  INDEX `fk_Aluno_has_Turma_Turma1_idx` (`idTurma` ASC) VISIBLE,
  INDEX `fk_Aluno_has_Turma_Aluno1_idx` (`CPF` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_has_Turma_Aluno1`
    FOREIGN KEY (`CPF`)
    REFERENCES `mydb`.`Aluno` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_has_Turma_Turma1`
    FOREIGN KEY (`idTurma`)
    REFERENCES `mydb`.`Turma` (`idTurma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
