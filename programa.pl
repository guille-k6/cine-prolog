:-dynamic(genero/2).
:-dynamic(zona/2).
:-dynamic(cine/3).
:-dynamic(horario/3).
:-dynamic(funcion/6).
:-dynamic(horariosUsuario/2).

abrir_db:-
  retractall(genero),
  retractall(zona),
  retractall(cine),
  retractall(horario),
  retractall(funcion),
  retractall(horariosUsuario),
  consult('C:/Users/PC/Desktop/Facultad/IA/Ejercicios/Finales/BaseSistemaExpertoV2.txt').

inicio:-
  abrir_db,
  saludar,
  consultarZonas(ZonasUsuarios),
  not(validarZonas(ZonasUsuarios)),
  consultarGeneros(GenerosUsuario),
  not(validarGeneros(GenerosUsuario)),
  consultarDuracionMaxima(DuracionUsuario),
  consultarHorarios(HorariosUsuario),
  not(validarHorarios(HorariosUsuario)),
  writeln('Estas son las peliculas que te pueden interesar...'),
  writeln('--------------------------------------'),
  recomendarFunciones(ZonasUsuarios,GenerosUsuario,DuracionUsuario,HorariosUsuario).
inicio.

saludar:-
  writeln('Bienvenido! Cual es tu nombre?'),
  read(X), nl,
  write('Hola '), write(X), writeln('! Voy a hacerte unas preguntas para conocer tus preferencias.').

% Sección zonas

consultarZonas(ZonasUsuarios):-
  nl,
  writeln('Primero voy a consultarte sobre que zona/s te quedan mas comodas para ir'),
  todasLasZonas(Zonas),
  abrir_db,
  generarZonasUsuario(Zonas, ZonasUsuarios).

todasLasZonas([H|T]):-
  retract(zona(H,_)),
  todasLasZonas(T).
todasLasZonas(_).

generarZonasUsuario([],[]).
generarZonasUsuario([H|T1],[H|T2]):-
  write('Te queda comoda la zona '),
  zona(H, NombreZona),
  write(NombreZona),
  write('? [s|n]'),
  read(Rta),
  Rta = 's',
  generarZonasUsuario(T1,T2).
generarZonasUsuario([_|T1],ZonasSeleccionadas):- generarZonasUsuario(T1,ZonasSeleccionadas).

validarZonas([]):-writeln('Que lastima! No conozco cines en otras zonas!'),fail.

% Sección genero

consultarGeneros(GenerosUsuarios):-
  nl,
  writeln('Ahora voy a hacerte unas preguntas sobre que generos son los que te gustan'),
  todosLosGeneros(Generos),
  abrir_db,
  generarGenerosUsuario(Generos, GenerosUsuarios).

todosLosGeneros([H|T]):-
  retract(genero(H,_)),
  todosLosGeneros(T).
todosLosGeneros(_).

generarGenerosUsuario([],[]).
generarGenerosUsuario([H|T1],[H|T2]):-
  write('Te interesa el genero '),
  genero(H, NombreGenero),
  write(NombreGenero),
  write('? [s|n]'),
  read(Rta),
  Rta = 's',
  generarGenerosUsuario(T1,T2).
generarGenerosUsuario([_|T1],GenerosSeleccionados):- generarGenerosUsuario(T1,GenerosSeleccionados).

validarGeneros([]):-writeln('Que lastima! No conozco otros generos!'),fail.

% Seccion duracion

consultarDuracionMaxima(DuracionUsuario):-
  nl,
  writeln('Ahora vamos a seguir con las preguntas'),
  nl,
  write('Cual es la duracion maxima que te interesa para una pelicula?'),
  read(DuracionUsuario).

% Seccion horarios

consultarHorarios(HorariosUsuario):-
  nl,
  writeln('Ahora voy a hacerte unas preguntas con respecto a que horarios te quedan mas comodos'),
  todosLosHorarios(Horarios),
  abrir_db,
  generarHorariosUsuario(Horarios, HorariosUsuario).

todosLosHorarios([H|T]):-
  retract(horario(H,_,_)),
  todosLosHorarios(T).
todosLosHorarios(_).

generarHorariosUsuario([],[]).
generarHorariosUsuario([H|T1],[H|T2]):-
  write('Te queda comodo de '),
  horario(H,_,_),
  write(H),
  write('? [s|n]'),
  read(Rta),
  Rta = 's',
  generarHorariosUsuario(T1,T2).
generarHorariosUsuario([_|T1],HorariosSeleccionados):- generarHorariosUsuario(T1,HorariosSeleccionados).

validarHorarios([]):-writeln('Que lastima! No hay otros horarios disponibles!'),fail.

% Seccion recomendar funciones

recomendarFunciones(ZonasUsuarios,GenerosUsuario,DuracionUsuario,HorariosUsuario):-
  retract(funcion(Nombre, IdGenero, Duracion, Horarios, IdCine, _)),
  pertenece(IdGenero,GenerosUsuario),
  Duracion =< DuracionUsuario,
  cine(IdCine,NombreCine,IdZona),
  zona(IdZona,NombreZona),
  genero(IdGenero,NombreGenero),
  pertenece(IdZona,ZonasUsuarios),
  chequearHorarios(HorariosUsuario),
  retract(horariosUsuario(D,H)),
  verHorarios(Horarios,D,H),

  write('> Nombre de la pelicula: '),
  writeln(Nombre),
  write('> Genero: '),
  writeln(NombreGenero),
  write('> Horarios de la funcion: '),
  writeln(Horarios),
  write('> Cine: '),
  writeln(NombreCine),
  write('> Zona: '),
  writeln(NombreZona),
  write('> Duracion: '),
  writeln(Duracion),
  writeln('--------------------------------------'),

  recomendarFunciones(ZonasUsuarios,GenerosUsuario,DuracionUsuario,HorariosUsuario).
recomendarFunciones(_,_,_,_).

chequearHorarios([]).
chequearHorarios([H|T]):-horario(H,Desde,Hasta),assert(horariosUsuario(Desde,Hasta)),chequearHorarios(T).

verHorarios([H|_],Desde,Hasta):-H>=Desde,H=<Hasta.
verHorarios([_|T],Desde,Hasta):-verHorarios(T,Desde,Hasta).

pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).
