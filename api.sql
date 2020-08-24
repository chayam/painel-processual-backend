SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


--
-- Banco de dados: `api`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `assunto`
--

DROP TABLE IF EXISTS `assunto`;
CREATE TABLE IF NOT EXISTS `assunto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(300) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `assunto`
--

INSERT INTO `assunto` (`id`, `descricao`, `ativo`) VALUES
(1, 'Solicitação de Férias', 1),
(2, 'Certidão Negativa', 1),
(3, 'Aposentadoria', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `log_processo`
--

DROP TABLE IF EXISTS `log_processo`;
CREATE TABLE IF NOT EXISTS `log_processo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processo_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `descricao` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `observacao` text COLLATE utf8_bin,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  `dt_criacao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_log_processo_processo1_idx` (`processo_id`),
  KEY `fk_log_processo_status1_idx` (`status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- --------------------------------------------------------

--
-- Estrutura da tabela `perfil`
--

DROP TABLE IF EXISTS `perfil`;
CREATE TABLE IF NOT EXISTS `perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(70) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `perfil`
--

INSERT INTO `perfil` (`id`, `nome`, `ativo`) VALUES
(1, 'Administrador', 1),
(2, 'Analista', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `processo`
--

DROP TABLE IF EXISTS `processo`;
CREATE TABLE IF NOT EXISTS `processo` (
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
  KEY `fk_processo_usuario1_idx` (`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Acionadores `processo`
--
DROP TRIGGER IF EXISTS `processo_AFTER_INSERT`;
DELIMITER $$
CREATE TRIGGER `processo_AFTER_INSERT` AFTER INSERT ON `processo` FOR EACH ROW BEGIN
	INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `processo_AFTER_UPDATE`;
DELIMITER $$
CREATE TRIGGER `processo_AFTER_UPDATE` AFTER UPDATE ON `processo` FOR EACH ROW BEGIN
	if(new.status_id <> old.status_id) then
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
    elseif ((new.descricao <> old.descricao)) THEN
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);    
    elseif ((new.observacao <> old.observacao)) THEN
		INSERT INTO log_processo (processo_id,status_id,descricao,observacao) VALUES (NEW.id,new.status_id,new.descricao,new.observacao);
    end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `requerente`
--

DROP TABLE IF EXISTS `requerente`;
CREATE TABLE IF NOT EXISTS `requerente` (
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- --------------------------------------------------------

--
-- Estrutura da tabela `setor`
--

DROP TABLE IF EXISTS `setor`;
CREATE TABLE IF NOT EXISTS `setor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `setor`
--

INSERT INTO `setor` (`id`, `nome`, `ativo`) VALUES
(1, 'Tecnologia da Informação', 1),
(2, 'Recursos Humanos', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) COLLATE utf8_bin NOT NULL,
  `ativo` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `status`
--

INSERT INTO `status` (`id`, `nome`, `ativo`) VALUES
(1, 'Em aberto', 1),
(2, 'Em análise', 1),
(3, 'Finalizado', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
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
  KEY `fk_usuario_setor1_idx` (`setor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id`, `perfil_id`, `setor_id`, `nome`, `email`, `matricula`, `senha`, `ativo`, `dt_criacao`) VALUES
(1, 1, 2, 'Joceli', 'joceli.pimenta@gmail.com', 1, 'abc123', 1, '2020-08-19 21:30:44');

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_painel_assunto_qtd`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_painel_assunto_qtd`;
CREATE TABLE IF NOT EXISTS `vw_painel_assunto_qtd` (
`requerente_id` int(11)
,`assunto` varchar(343)
,`qtds` varchar(258)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_painel_qtd`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_painel_qtd`;
CREATE TABLE IF NOT EXISTS `vw_painel_qtd` (
`requerente_id` int(11)
,`aberto` bigint(21)
,`analise` bigint(21)
,`finalizado` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_painel_req_proc_ano`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_painel_req_proc_ano`;
CREATE TABLE IF NOT EXISTS `vw_painel_req_proc_ano` (
`requerente_id` int(11)
,`ano` varchar(258)
,`qtd` varchar(258)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_processos`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_processos`;
CREATE TABLE IF NOT EXISTS `vw_processos` (
`id` int(11)
,`requerente_id` int(11)
,`usuario_id` int(11)
,`analista` varchar(100)
,`assunto_id` int(11)
,`assunto` varchar(300)
,`status_id` int(11)
,`status` varchar(45)
,`numero` int(11)
,`descricao` varchar(100)
,`observacao` text
,`dt_criacao` timestamp
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_requerente`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_requerente`;
CREATE TABLE IF NOT EXISTS `vw_requerente` (
`id` int(11)
,`nome` varchar(100)
,`cpf` varchar(11)
,`telefone` varchar(14)
,`email` varchar(100)
,`senha` varchar(100)
,`dt_aniversario` varchar(10)
);

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_painel_assunto_qtd`
--
DROP TABLE IF EXISTS `vw_painel_assunto_qtd`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_painel_assunto_qtd`  AS  select `a`.`requerente_id` AS `requerente_id`,concat('[',group_concat(concat('\'',`a`.`descricao`,'\'') separator ', '),']') AS `assunto`,concat('[',group_concat(`a`.`qtd` separator ', '),']') AS `qtds` from (select `b`.`requerente_id` AS `requerente_id`,`b`.`assunto_id` AS `assunto_id`,`a`.`descricao` AS `descricao`,count(0) AS `qtd` from ((`assunto` `a` join `processo` `b` on((`b`.`assunto_id` = `a`.`id`))) join `requerente` `c` on((`b`.`requerente_id` = `c`.`id`))) group by `b`.`requerente_id`,`b`.`assunto_id`) `a` group by `a`.`requerente_id` order by `a`.`requerente_id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_painel_qtd`
--
DROP TABLE IF EXISTS `vw_painel_qtd`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_painel_qtd`  AS  select `a`.`id` AS `requerente_id`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 1))) AS `aberto`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 2))) AS `analise`,(select count(0) from `processo` `sb` where ((`sb`.`requerente_id` = `a`.`id`) and (`sb`.`status_id` = 3))) AS `finalizado` from `requerente` `a` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_painel_req_proc_ano`
--
DROP TABLE IF EXISTS `vw_painel_req_proc_ano`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_painel_req_proc_ano`  AS  select `a`.`requerente_id` AS `requerente_id`,concat('[',group_concat(concat('\'',`a`.`ano`,'\'') separator ', '),']') AS `ano`,concat('[',group_concat(`a`.`qtd` separator ', '),']') AS `qtd` from (select `a`.`requerente_id` AS `requerente_id`,date_format(`a`.`dt_criacao`,'%Y') AS `ano`,count(0) AS `qtd` from `processo` `a` group by `a`.`requerente_id`,date_format(`a`.`dt_criacao`,'%Y') order by `a`.`dt_criacao`) `a` group by `a`.`requerente_id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_processos`
--
DROP TABLE IF EXISTS `vw_processos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_processos`  AS  select `a`.`id` AS `id`,`a`.`requerente_id` AS `requerente_id`,`a`.`usuario_id` AS `usuario_id`,`e`.`nome` AS `analista`,`a`.`assunto_id` AS `assunto_id`,`c`.`descricao` AS `assunto`,`a`.`status_id` AS `status_id`,`d`.`nome` AS `status`,`a`.`numero` AS `numero`,`a`.`descricao` AS `descricao`,`a`.`observacao` AS `observacao`,`a`.`dt_criacao` AS `dt_criacao` from ((((`processo` `a` join `requerente` `b` on((`a`.`requerente_id` = `b`.`id`))) join `assunto` `c` on((`a`.`assunto_id` = `c`.`id`))) join `status` `d` on((`a`.`status_id` = `d`.`id`))) left join `usuario` `e` on((`a`.`usuario_id` = `e`.`id`))) ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_requerente`
--
DROP TABLE IF EXISTS `vw_requerente`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_requerente`  AS  select `a`.`id` AS `id`,`a`.`nome` AS `nome`,`a`.`cpf` AS `cpf`,`a`.`telefone` AS `telefone`,`a`.`email` AS `email`,`a`.`senha` AS `senha`,date_format(`a`.`dt_aniversario`,'%d-%m-%Y') AS `dt_aniversario` from `requerente` `a` where ((1 = 1) and (`a`.`ativo` = 1)) ;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `log_processo`
--
ALTER TABLE `log_processo`
  ADD CONSTRAINT `fk_log_processo_processo1` FOREIGN KEY (`processo_id`) REFERENCES `processo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_log_processo_status1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `processo`
--
ALTER TABLE `processo`
  ADD CONSTRAINT `fk_processo_assunto1` FOREIGN KEY (`assunto_id`) REFERENCES `assunto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_processo_requerente1` FOREIGN KEY (`requerente_id`) REFERENCES `requerente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_processo_status1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_processo_usuario1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_perfil1` FOREIGN KEY (`perfil_id`) REFERENCES `perfil` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_setor1` FOREIGN KEY (`setor_id`) REFERENCES `setor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
