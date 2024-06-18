USE BBDD_EmilianoDelia

CREATE TABLE comunidades_autonomas (
    codigo_pais INT,
    nombre_pais VARCHAR(50),
    codigo_com_autonoma VARCHAR(2),
    nombre_com_autonoma VARCHAR(100),
    cod_provincia VARCHAR(2),
    nombre_provincia VARCHAR(100)
);

INSERT INTO comunidades_autonomas (codigo_pais, nombre_pais, codigo_com_autonoma, nombre_com_autonoma, cod_provincia, nombre_provincia)
VALUES
		(724, 'ESPA�A', 'PV', 'COMUNIDAD AUTONOMA DEL PAIS VASCO', '01', 'ARABA/ALAVA'),
		(724, 'ESPA�A', 'CM', 'COMUNIDAD AUTONOMA DE CASTILLA-LA MANCHA', '02', 'ALBACETE'),
		(724, 'ESPA�A', 'CV', 'COMUNIDAD VALENCIANA', '03', 'ALICANTE - ALACANT'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '04', 'ALMERIA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '05', 'AVILA'),
		(724, 'ESPA�A', 'EX', 'COMUNIDAD AUTONOMA DE EXTREMADURA', '06', 'BADAJOZ'),
		(724, 'ESPA�A', 'IB', 'COMUNIDAD AUTONOMA DE ILLES BALEARS', '07', 'ILLES BALEARS'),
		(724, 'ESPA�A', 'CT', 'COMUNIDAD AUTONOMA DE CATALU�A', '08', 'BARCELONA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '09', 'BURGOS'),
		(724, 'ESPA�A', 'EX', 'COMUNIDAD AUTONOMA DE EXTREMADURA', '10', 'CACERES'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '11', 'CADIZ'),
		(724, 'ESPA�A', 'CV', 'COMUNIDAD VALENCIANA', '12', 'CASTELLON/CASTELLO'),
		(724, 'ESPA�A', 'CM', 'COMUNIDAD AUTONOMA DE CASTILLA-LA MANCHA', '13', 'CIUDAD REAL'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '14', 'CORDOBA'),
		(724, 'ESPA�A', 'GA', 'COMUNIDAD AUTONOMA DE GALICIA', '15', 'A CORU�A'),
		(724, 'ESPA�A', 'CM', 'COMUNIDAD AUTONOMA DE CASTILLA-LA MANCHA', '16', 'CUENCA'),
		(724, 'ESPA�A', 'CT', 'COMUNIDAD AUTONOMA DE CATALU�A', '17', 'GIRONA'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '18', 'GRANADA'),
		(724, 'ESPA�A', 'CM', 'COMUNIDAD AUTONOMA DE CASTILLA-LA MANCHA', '19', 'GUADALAJARA'),
		(724, 'ESPA�A', 'PV', 'COMUNIDAD AUTONOMA DEL PAIS VASCO', '20', 'GIPUZKOA'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '21', 'HUELVA'),
		(724, 'ESPA�A', 'AR', 'COMUNIDAD AUTONOMA DE ARAGON', '22', 'HUESCA'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '23', 'JAEN'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '24', 'LEON'),
		(724, 'ESPA�A', 'CT', 'COMUNIDAD AUTONOMA DE CATALU�A', '25', 'LLEIDA'),
		(724, 'ESPA�A', 'LR', 'COMUNIDAD AUTONOMA DE LA RIOJA', '26', 'LA RIOJA'),
		(724, 'ESPA�A', 'GA', 'COMUNIDAD AUTONOMA DE GALICIA', '27', 'LUGO'),
		(724, 'ESPA�A', 'MD', 'COMUNIDAD DE MADRID', '28', 'MADRID'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '29', 'MALAGA'),
		(724, 'ESPA�A', 'MU', 'REGION DE MURCIA', '30', 'MURCIA'),
		(724, 'ESPA�A', 'NA', 'COMUNIDAD FORAL DE NAVARRA', '31', 'NAVARRA'),
		(724, 'ESPA�A', 'GA', 'COMUNIDAD AUTONOMA DE GALICIA', '32', 'OURENSE'),
		(724, 'ESPA�A', 'AS', 'PRINCIPADO DE ASTURIAS', '33', 'ASTURIAS'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '34', 'PALENCIA'),
		(724, 'ESPA�A', 'IC', 'COMUNIDAD AUTONOMA DE CANARIAS', '35', 'LAS PALMAS'),
		(724, 'ESPA�A', 'GA', 'COMUNIDAD AUTONOMA DE GALICIA', '36', 'PONTEVEDRA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '37', 'SALAMANCA'),
		(724, 'ESPA�A', 'IC', 'COMUNIDAD AUTONOMA DE CANARIAS', '38', 'S. C. TENERIFE'),
		(724, 'ESPA�A', 'CN', 'COMUNIDAD AUTONOMA DE CANTABRIA', '39', 'CANTABRIA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '40', 'SEGOVIA'),
		(724, 'ESPA�A', 'AN', 'COMUNIDAD AUTONOMA DE ANDALUCIA', '41', 'SEVILLA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '42', 'SORIA'),
		(724, 'ESPA�A', 'CT', 'COMUNIDAD AUTONOMA DE CATALU�A', '43', 'TARRAGONA'),
		(724, 'ESPA�A', 'AR', 'COMUNIDAD AUTONOMA DE ARAGON', '44', 'TERUEL'),
		(724, 'ESPA�A', 'CM', 'COMUNIDAD AUTONOMA DE CASTILLA-LA MANCHA', '45', 'TOLEDO'),
		(724, 'ESPA�A', 'CV', 'COMUNIDAD VALENCIANA', '46', 'VALENCIA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '47', 'VALLADOLID'),
		(724, 'ESPA�A', 'PV', 'COMUNIDAD AUTONOMA DEL PAIS VASCO', '48', 'BIZKAIA'),
		(724, 'ESPA�A', 'CL', 'COMUNIDAD AUTONOMA DE CASTILLA Y LEON', '49', 'ZAMORA'),
		(724, 'ESPA�A', 'AR', 'COMUNIDAD AUTONOMA DE ARAGON', '50', 'ZARAGOZA'),
		(724, 'ESPA�A', 'CE', 'CIUDAD DE CEUTA', '51', 'CEUTA'),
		(724, 'ESPA�A', 'ME', 'CIUDAD DE MELILLA', '52', 'MELILLA');