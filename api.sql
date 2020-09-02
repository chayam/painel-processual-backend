-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.7.28


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema apiportfolio
--

CREATE DATABASE IF NOT EXISTS apiportfolio;
USE apiportfolio;

--
-- Temporary table structure for view `vw_painel_assunto_qtd`
--
DROP TABLE IF EXISTS `vw_painel_assunto_qtd`;
DROP VIEW IF EXISTS `vw_painel_assunto_qtd`;
CREATE TABLE `vw_painel_assunto_qtd` (
  `requerente_id` int(11),
  `assunto` varchar(343),
  `qtds` varchar(343)
);

--
-- Temporary table structure for view `vw_painel_qtd`
--
DROP TABLE IF EXISTS `vw_painel_qtd`;
DROP VIEW IF EXISTS `vw_painel_qtd`;
CREATE TABLE `vw_painel_qtd` (
  `requerente_id` int(11),
  `aberto` bigint(21),
  `analise` bigint(21),
  `finalizado` bigint(21)
);

--
-- Temporary table structure for view `vw_painel_req_proc_ano`
--
DROP TABLE IF EXISTS `vw_painel_req_proc_ano`;
DROP VIEW IF EXISTS `vw_painel_req_proc_ano`;
CREATE TABLE `vw_painel_req_proc_ano` (
  `requerente_id` int(11),
  `ano` varchar(343),
  `qtd` varchar(343)
);

--
-- Temporary table structure for view `vw_processos`
--
DROP TABLE IF EXISTS `vw_processos`;
DROP VIEW IF EXISTS `vw_processos`;
CREATE TABLE `vw_processos` (
  `id` int(11),
  `requerente_id` int(11),
  `usuario_id` int(11),
  `analista` varchar(100),
  `assunto_id` int(11),
  `assunto` varchar(300),
  `status_id` int(11),
  `status` varchar(45),
  `numero` int(11),
  `descricao` varchar(100),
  `observacao` text,
  `dt_criacao` timestamp
);

--
-- Temporary table structure for view `vw_requerente`
--
DROP TABLE IF EXISTS `vw_requerente`;
DROP VIEW IF EXISTS `vw_requerente`;
CREATE TABLE `vw_requerente` (
  `id` int(11),
  `nome` varchar(100),
  `cpf` varchar(11),
  `telefone` varchar(14),
  `email` varchar(100),
  `senha` varchar(100),
  `dt_aniversario` varchar(10)
);

--
-- Definition of table `assunto`
--

DROP TABLE IF EXISTS `assunto`;
CREATE TABLE `assunto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(300) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `assunto`
--

/*!40000 ALTER TABLE `assunto` DISABLE KEYS */;
INSERT INTO `assunto` (`id`,`descricao`,`ativo`) VALUES 
 (1,0x536F6C6963697461C3A7C3A36F2064652046C3A972696173,1),
 (2,0x436572746964C3A36F204E65676174697661,1),
 (3,0x41706F73656E7461646F726961,1);
/*!40000 ALTER TABLE `assunto` ENABLE KEYS */;


--
-- Definition of table `log_processo`
--

DROP TABLE IF EXISTS `log_processo`;
CREATE TABLE `log_processo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processo_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `descricao` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `observacao` text COLLATE utf8_bin,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  `dt_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_log_processo_processo1_idx` (`processo_id`),
  KEY `fk_log_processo_status1_idx` (`status_id`),
  CONSTRAINT `fk_log_processo_processo1` FOREIGN KEY (`processo_id`) REFERENCES `processo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_processo_status1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;




--
-- Definition of table `perfil`
--

DROP TABLE IF EXISTS `perfil`;
CREATE TABLE `perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(70) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `perfil`
--

/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` (`id`,`nome`,`ativo`) VALUES 
 (1,0x41646D696E6973747261646F72,1),
 (2,0x416E616C69737461,1);
/*!40000 ALTER TABLE `perfil` ENABLE KEYS */;


--
-- Definition of table `processo`
--

DROP TABLE IF EXISTS `processo`;
CREATE TABLE `processo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `requerente_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `assunto_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `descricao` varchar(100) COLLATE utf8_bin NOT NULL,
  `observacao` text COLLATE utf8_bin NOT NULL,
  `dt_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_processo_status1_idx` (`status_id`),
  KEY `fk_processo_requerente1_idx` (`requerente_id`),
  KEY `fk_processo_assunto1_idx` (`assunto_id`),
  KEY `fk_processo_usuario1_idx` (`usuario_id`),
  CONSTRAINT `fk_processo_assunto1` FOREIGN KEY (`assunto_id`) REFERENCES `assunto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_processo_requerente1` FOREIGN KEY (`requerente_id`) REFERENCES `requerente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_processo_status1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_processo_usuario1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



--
-- Definition of trigger `processo_AFTER_INSERT`
--

DROP TRIGGER /*!50030 IF EXISTS */ `processo_AFTER_INSERT`;

DELIMITER $$

CREATE  TRIGGER `processo_AFTER_INSERT` AFTER INSERT ON `processo` FOR EACH ROW BEGIN
	INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
END $$

DELIMITER ;

--
-- Definition of trigger `processo_AFTER_UPDATE`
--

DROP TRIGGER /*!50030 IF EXISTS */ `processo_AFTER_UPDATE`;

DELIMITER $$

CREATE  TRIGGER `processo_AFTER_UPDATE` AFTER UPDATE ON `processo` FOR EACH ROW BEGIN
	if(new.status_id <> old.status_id) then
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
    elseif ((new.descricao <> old.descricao)) THEN
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);    
    elseif ((new.observacao <> old.observacao)) THEN
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
    end if;
END $$

DELIMITER ;

--
-- Definition of table `requerente`
--

DROP TABLE IF EXISTS `requerente`;
CREATE TABLE `requerente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8_bin NOT NULL,
  `cpf` varchar(11) COLLATE utf8_bin NOT NULL,
  `telefone` varchar(14) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_bin NOT NULL,
  `dt_aniversario` date DEFAULT NULL,
  `dt_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  `senha` varchar(100) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


--
-- Definition of table `setor`
--

DROP TABLE IF EXISTS `setor`;
CREATE TABLE `setor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `setor`
--

/*!40000 ALTER TABLE `setor` DISABLE KEYS */;
INSERT INTO `setor` (`id`,`nome`,`ativo`) VALUES 
 (1,0x5465636E6F6C6F67696120646120496E666F726D61C3A7C3A36F,1),
 (2,0x5265637572736F732048756D616E6F73,1);
/*!40000 ALTER TABLE `setor` ENABLE KEYS */;


--
-- Definition of table `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `status`
--

/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` (`id`,`nome`,`ativo`) VALUES 
 (1,0x456D2061626572746F,1),
 (2,0x456D20616EC3A16C697365,1),
 (3,0x46696E616C697A61646F,1);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;


--
-- Definition of table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perfil_id` int(11) NOT NULL,
  `setor_id` int(11) NOT NULL,
  `nome` varchar(100) COLLATE utf8_bin NOT NULL,
  `email` varchar(100) COLLATE utf8_bin NOT NULL,
  `matricula` int(11) NOT NULL,
  `senha` varchar(100) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  `dt_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_usuario_perfil1_idx` (`perfil_id`),
  KEY `fk_usuario_setor1_idx` (`setor_id`),
  CONSTRAINT `fk_usuario_perfil1` FOREIGN KEY (`perfil_id`) REFERENCES `perfil` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_setor1` FOREIGN KEY (`setor_id`) REFERENCES `setor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Definition of view `vw_painel_assunto_qtd`
--

DROP TABLE IF EXISTS `vw_painel_assunto_qtd`;
DROP VIEW IF EXISTS `vw_painel_assunto_qtd`;
CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_painel_assunto_qtd` AS select `sb`.`requerente_id` AS `requerente_id`,concat('[',group_concat(concat('"',`sb`.`assunto`,'"') order by `sb`.`requerente_id` ASC,`sb`.`assunto` ASC separator ', '),']') AS `assunto`,concat('[',group_concat(concat('"',`sb`.`qtds`,'"') order by `sb`.`requerente_id` ASC,`sb`.`assunto` ASC separator ', '),']') AS `qtds` from (select `a`.`requerente_id` AS `requerente_id`,`a`.`assunto` AS `assunto`,`a`.`qtds` AS `qtds` from (select `b`.`requerente_id` AS `requerente_id`,`a`.`descricao` AS `assunto`,NULL AS `qtds` from ((`apiportfolio`.`assunto` `a` join `apiportfolio`.`processo` `b` on((`b`.`assunto_id` = `a`.`id`))) join `apiportfolio`.`requerente` `c` on((`b`.`requerente_id` = `c`.`id`))) group by `b`.`requerente_id`,`b`.`assunto_id`) `a` union all select `b`.`requerente_id` AS `requerente_id`,`b`.`assunto` AS `assunto`,`b`.`qtds` AS `qtds` from (select `b`.`requerente_id` AS `requerente_id`,NULL AS `assunto`,count(0) AS `qtds` from ((`apiportfolio`.`assunto` `a` join `apiportfolio`.`processo` `b` on((`b`.`assunto_id` = `a`.`id`))) join `apiportfolio`.`requerente` `c` on((`b`.`requerente_id` = `c`.`id`))) group by `b`.`requerente_id`,`b`.`assunto_id`) `b`) `sb` group by `sb`.`requerente_id`;

--
-- Definition of view `vw_painel_qtd`
--

DROP TABLE IF EXISTS `vw_painel_qtd`;
DROP VIEW IF EXISTS `vw_painel_qtd`;
CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_painel_qtd` AS select `a`.`id` AS `requerente_id`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 1))) AS `aberto`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 2))) AS `analise`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 3))) AS `finalizado` from `requerente` `a`;

--
-- Definition of view `vw_painel_req_proc_ano`
--

DROP TABLE IF EXISTS `vw_painel_req_proc_ano`;
DROP VIEW IF EXISTS `vw_painel_req_proc_ano`;
CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_painel_req_proc_ano` AS select `a`.`requerente_id` AS `requerente_id`,concat('[',group_concat(concat('"',`a`.`ano`,'"') separator ', '),']') AS `ano`,concat('[',group_concat(`a`.`qtd` separator ', '),']') AS `qtd` from (select `a`.`requerente_id` AS `requerente_id`,date_format(`a`.`dt_criacao`,'%Y') AS `ano`,count(0) AS `qtd` from `apiportfolio`.`processo` `a` group by `a`.`requerente_id`,date_format(`a`.`dt_criacao`,'%Y') order by `a`.`dt_criacao`) `a` group by `a`.`requerente_id`;

--
-- Definition of view `vw_processos`
--

DROP TABLE IF EXISTS `vw_processos`;
DROP VIEW IF EXISTS `vw_processos`;
CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_processos` AS select `a`.`id` AS `id`,`a`.`requerente_id` AS `requerente_id`,`a`.`usuario_id` AS `usuario_id`,`e`.`nome` AS `analista`,`a`.`assunto_id` AS `assunto_id`,`c`.`descricao` AS `assunto`,`a`.`status_id` AS `status_id`,`d`.`nome` AS `status`,`a`.`numero` AS `numero`,`a`.`descricao` AS `descricao`,`a`.`observacao` AS `observacao`,`a`.`dt_criacao` AS `dt_criacao` from ((((`processo` `a` join `requerente` `b` on((`a`.`requerente_id` = `b`.`id`))) join `assunto` `c` on((`a`.`assunto_id` = `c`.`id`))) join `status` `d` on((`a`.`status_id` = `d`.`id`))) left join `usuario` `e` on((`a`.`usuario_id` = `e`.`id`))) order by `a`.`dt_criacao`;

--
-- Definition of view `vw_requerente`
--

DROP TABLE IF EXISTS `vw_requerente`;
DROP VIEW IF EXISTS `vw_requerente`;
CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `vw_requerente` AS select `a`.`id` AS `id`,`a`.`nome` AS `nome`,`a`.`cpf` AS `cpf`,`a`.`telefone` AS `telefone`,`a`.`email` AS `email`,`a`.`senha` AS `senha`,date_format(`a`.`dt_aniversario`,'%d-%m-%Y') AS `dt_aniversario` from `requerente` `a` where ((1 = 1) and (`a`.`ativo` = 1));



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
