-- Listar todos los alumnos con el estado de su expediente
SELECT 
    A.ID_Alumno, 
    A.Nombre + ' ' + A.Apellidos AS Alumno, 
    A.Edad, 
    A.Localidad,
    EA.Estado_Expediente,
    CASE 
        WHEN EA.Comprobante_Domicilio = 'SI' AND EA.Certificado_Medico = 'SI' 
             AND EA.Fotos = 'SI' AND EA.Recibo_Pago = 'SI' 
             AND EA.Carta_Compromiso = 'SI' AND EA.CURP = 'SI'
        THEN 'COMPLETO'
        ELSE 'INCOMPLETO'
    END AS Documentacion
FROM Alumno A
JOIN Expediente_Alumno EA ON A.ID_Alumno = EA.ID_Alumno
ORDER BY A.Apellidos;

-- Mostrar talleres con información de los docentes asignados
SELECT 
    T.ID_Taller,
    T.Nombre AS Taller,
    T.Localidad AS Ubicacion,
    T.Horario,
    D.Nombre + ' ' + D.Apellidos AS Docente,
    DT.Carga_horaria AS [Horas Semanales],
    D.Contacto AS [Teléfono Docente]
FROM Taller T
LEFT JOIN Docente_Taller DT ON T.ID_Taller = DT.ID_Taller
LEFT JOIN Docente D ON DT.ID_Docente = D.ID_Docente
ORDER BY T.Nombre;

-- Buscar asistencias con observaciones o estados diferentes a "PRESENTE"
SELECT 
    A.ID_Alumno,
    AL.Nombre + ' ' + AL.Apellidos AS Alumno,
    T.Nombre AS Taller,
    ASIS.Fecha,
    ASIS.Estado,
    ASIS.Observaciones
FROM Asistencia ASIS
JOIN Alumno AL ON ASIS.ID_Alumno = AL.ID_Alumno
JOIN Taller T ON ASIS.ID_Taller = T.ID_Taller
WHERE ASIS.Estado != 'PRESENTE' OR ASIS.Observaciones IS NOT NULL
ORDER BY ASIS.Fecha DESC;

-- Identificar qué documentos faltan en los expedientes incompletos
SELECT 
    A.ID_Alumno,
    A.Nombre + ' ' + A.Apellidos AS Alumno,
    EA.Estado_Expediente,
    CASE WHEN EA.Comprobante_Domicilio = 'NO' THEN 'Comprobante domicilio, ' ELSE '' END +
    CASE WHEN EA.Certificado_Medico = 'NO' THEN 'Certificado médico, ' ELSE '' END +
    CASE WHEN EA.Fotos = 'NO' THEN 'Fotos, ' ELSE '' END +
    CASE WHEN EA.Recibo_Pago = 'NO' THEN 'Recibo pago, ' ELSE '' END +
    CASE WHEN EA.Carta_Compromiso = 'NO' THEN 'Carta compromiso, ' ELSE '' END +
    CASE WHEN EA.CURP = 'NO' THEN 'CURP' ELSE '' END AS [Documentos Faltantes]
FROM Alumno A
JOIN Expediente_Alumno EA ON A.ID_Alumno = EA.ID_Alumno
WHERE EA.Comprobante_Domicilio = 'NO' 
   OR EA.Certificado_Medico = 'NO'
   OR EA.Fotos = 'NO'
   OR EA.Recibo_Pago = 'NO'
   OR EA.Carta_Compromiso = 'NO'
   OR EA.CURP = 'NO';