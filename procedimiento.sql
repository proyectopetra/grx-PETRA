-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- authors: Antonio Fernández Ares
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `localizaTrazasNodos2`(in fechaMIN Varchar(40), in fechaMAX Varchar(40), in intervalo INT)
BEGIN

DECLARE inter INT DEFAULT intervalo*1000*60;
DECLARE corte INT DEFAULT 19;

DECLARE fMax bigint(20) DEFAULT UNIX_TIMESTAMP(fechaMAX)*1000;
DECLARE fMin bigint(20) DEFAULT UNIX_TIMESTAMP(fechaMIN)*1000;

DECLARE i bigint(20) DEFAULT fMIN;

IF intervalo >= 1440 THEN SET corte = 10; END IF;

DROP TEMPORARY TABLE IF EXISTS trazas;

CREATE TEMPORARY TABLE trazas  (Origen bigint(20), tiempo bigint(20), Destino bigint(20), Destino_tiempo bigint(20)) ENGINE=MEMORY;

WHILE (i+inter<=fMaX) DO
	INSERT INTO trazas
		SELECT STRAIGHT_JOIN
		t1.idNodo as Origen,
		t1.tinicio as tiempo,
		t2.idNodo as Destino,
		t2.tinicio as Destino_tiempo
	FROM
		(SELECT idNodo,tinicio,idDispositivo FROM __paso
			WHERE tinicio
					BETWEEN  i
					AND  i+inter 
		) as t1
		INNER JOIN 
			(SELECT idNodo,tinicio,idDispositivo FROM __paso 
				WHERE tinicio
					BETWEEN  i-inter
					AND  i+inter+inter 
			) as t2 
			ON	
				t1.idDispositivo = t2.idDispositivo 
				AND t1.idNodo <> t2.idNodo
				AND (t2.tinicio - t1.tinicio) BETWEEN 0 AND inter;

SET i = i + inter;

END WHILE;

SELECT t.Fecha, t.Origen, t.Destino, t.total, t.Diferencia, t1.latitud, t1.longitud, t2.latitud, t2.longitud  FROM

		(SELECT 	SUBSTR(FROM_UNIXTIME(truncate(tiempo/inter,0)*inter/1000),1,corte) as Fecha,
			Origen,
			Destino,
			count(*) as total,
			avg(Destino_tiempo - tiempo)/1000 as Diferencia
		FROM trazas
		GROUP BY Origen, Destino, truncate(tiempo/inter,0)
		ORDER BY fecha DESC) as t

INNER JOIN (SELECT latitud,longitud,idNodo from nodo) as t1 ON t.Origen = t1.idNodo
INNER JOIN (SELECT latitud,longitud,idNodo from nodo) as t2 ON t.Destino = t2.idNodo
		

;


END
