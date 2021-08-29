% jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

% tiene(Nombre, unidad(Que, Cuantas)).
% tiene(Nombre, recurso(Madera, Alimento, Oro)).
% tiene(aleP, edificio(Cual, Cuantos)).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(aleP, unidad(cazador, 10)).
tiene(juan, unidad(carreta, 10)).
tiene(marti, unidad(espadachin, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).

% -------------- PUNTO 1 --------------

esUnAfano(UnJugador, OtroJugador) :-
    jugador(UnJugador, RatingJugadorUno, _),
    jugador(OtroJugador, RatingJugadorDos, _),
    Diferencia is RatingJugadorUno - RatingJugadorDos,
    Diferencia > 500.

% -------------- PUNTO 2 --------------

esEfectivo(UnaUnidad, OtraUnidad) :-
    militar(UnaUnidad, _, CategoriaDelPrimero),
    militar(OtraUnidad, _, CategoriaDelSegundo),
    puedeGanarle(CategoriaDelPrimero, CategoriaDelSegundo).

esEfectivo(samurai, OtraUnidad) :-
    militar(OtraUnidad, _, unica).

puedeGanarle(caballeria, arqueria).
puedeGanarle(arqueria, infanteria).
puedeGanarle(infanteria, piquero).
puedeGanarle(piquero, caballeria).

% -------------- PUNTO 3 --------------

alarico(Jugador) :-
    tiene(Jugador, _),
    tieneTodosDeUnaCategoria(Jugador, infanteria).

tieneTodosDeUnaCategoria(Jugador, Categoria) :-
    forall(tiene(Jugador, unidad(Unidad, _)), militar(Unidad, _, Categoria)).

% -------------- PUNTO 4 --------------

leonidas(Jugador) :-
    tiene(Jugador, _),
    tieneTodosDeUnaCategoria(Jugador, piquero).

% -------------- PUNTO 5 --------------

nomada(Jugador) :-
    jugador(Jugador, _, _),
    not(tiene(Jugador, edificio(casa, _))).

% -------------- PUNTO 6 --------------

cuantoCuesta(Unidad, Madera, Alimento, Oro) :-
    militar(Unidad, costo(Madera, Alimento, Oro), _).

cuantoCuesta(Edificio, Madera, Alimento, Oro) :-
    edificio(Edificio, costo(Madera, Alimento, Oro)).

cuantoCuesta(Aldeano, 0, 50, 0) :-
    aldeano(Aldeano, _).

cuantoCuesta(carreta, 100, 50).

cuantoCuesta(urnasMercantes, 100, 50).

% -------------- PUNTO 7 --------------

produccion(Unidad, Madera, Alimento, Oro) :-
    aldeano(Unidad, produce(Madera, Alimento, Oro)).

produccion(carreta, 0, 0, 32).

produccion(urnasMercantes, 0, 0, 32).

produccion(keshik, 0, 0, 10).

% -------------- PUNTO 8 --------------

produccionTotal(Jugador, ProduccionTotal, Recurso) :-
    jugador(Jugador, _, _),
    recurso(Recurso),
    findall(Produccion, produccionDeRecursoPorJugador(Jugador, Produccion, Recurso), Producciones), 
    sum_list(Producciones, ProduccionTotal).

recurso(madera).
recurso(oro).
recurso(alimento).

produccionDeRecursoPorJugador(Jugador, Produccion, Recurso) :-
    tiene(Jugador, unidad(Unidad, Cantidad)),
    produccionPorCantidadDeUnidades(Unidad, Cantidad, Produccion, Recurso).

produccionPorCantidadDeUnidades(Unidad, Cantidad, Madera, madera) :-
    produccion(Unidad, MaderaProduce, _, _),
    Madera is MaderaProduce * Cantidad.

produccionPorCantidadDeUnidades(Unidad, Cantidad, Alimento, alimento) :-
    produccion(Unidad, _, AlimentoProduce, _),
    Alimento is AlimentoProduce * Cantidad.

produccionPorCantidadDeUnidades(Unidad, Cantidad, Oro, oro) :-
    produccion(Unidad, _, _, OroProduce),
    Oro is OroProduce * Cantidad.

% -------------- PUNTO 9 --------------

estaPeleado(UnJugador, OtroJugador) :-
    jugador(UnJugador, _, _),
    jugador(OtroJugador, _, _),
    UnJugador \= OtroJugador,
    noEsUnAfanoParaNinguno(UnJugador, OtroJugador),
    cantidadUnidadesPorJugador(UnJugador, CantidadUnidades),
    cantidadUnidadesPorJugador(OtroJugador, CantidadUnidades), 
    diferenciaDeProduccionesMenorACien(UnJugador, OtroJugador).

cantidadUnidadesPorJugador(UnJugador, CantidadUnidades) :-
    findall(Cantidad, tiene(UnJugador, unidad(_, Cantidad)), Cantidades),
    sum_list(Cantidades, CantidadUnidades).

noEsUnAfanoParaNinguno(UnJugador, OtroJugador) :-
    not(esUnAfano(UnJugador, OtroJugador)),
    not(esUnAfano(OtroJugador, UnJugador)).

diferenciaDeProduccionesMenorACien(UnJugador, OtroJugador) :-
    diferenciaMenorACienPorRecurso(UnJugador, OtroJugador, madera),
    diferenciaMenorACienPorRecurso(UnJugador, OtroJugador, alimento),
    diferenciaMenorACienPorRecurso(UnJugador, OtroJugador, oro).

diferenciaMenorACienPorRecurso(UnJugador, OtroJugador, Recurso) :-
    produccionTotal(UnJugador, ProduccionTotal1, Recurso),
    produccionTotal(OtroJugador, ProduccionTotal2, Recurso),
    calcularValorPorRecurso(ProduccionTotal1, ValorProduccion1, Recurso),
    calcularValorPorRecurso(ProduccionTotal2, ValorProduccion2, Recurso),
    diferenciaMenorACien(ValorProduccion1, ValorProduccion2).

diferenciaMenorACien(UnNumero, OtroNumero) :-
    Diferencia is UnNumero - OtroNumero,
    abs(Diferencia, ValorAbsoluto),
    ValorAbsoluto =< 100.

calcularValorPorRecurso(ProduccionTotal, ValorProduccion, oro) :-
    ValorProduccion is ProduccionTotal * 5.

calcularValorPorRecurso(ProduccionTotal, ValorProduccion, madera) :-
    ValorProduccion is ProduccionTotal * 3.

calcularValorPorRecurso(ProduccionTotal, ValorProduccion, alimento) :-
    ValorProduccion is ProduccionTotal * 2.

% -------------- PUNTO 10 --------------

avanzaA(UnJugador, Edad) :-
    jugador(UnJugador, _, _),
    puedeAvanzar(UnJugador, Edad).

puedeAvanzar(_, edadMedia).

puedeAvanzar(UnJugador, edadFeudal) :-
    cantidadMinimaSegunRecurso(UnJugador, alimento, 500),
    tiene(UnJugador, edificio(casa, _)).

puedeAvanzar(UnJugador, edadDeLosCastillos) :-
    cantidadMinimaSegunRecurso(UnJugador, alimento, 800),
    cantidadMinimaSegunRecurso(UnJugador, oro, 200),
    tieneEdificioNecesarioParaAvanzar(UnJugador, edadDeLosCastillos).

puedeAvanzar(UnJugador, edadImperial) :-
    cantidadMinimaSegunRecurso(UnJugador, alimento, 1000),
    cantidadMinimaSegunRecurso(UnJugador, oro, 800),
    tieneEdificioNecesarioParaAvanzar(UnJugador, edadImperial).

tieneEdificioNecesarioParaAvanzar(UnJugador, Edad) :-
    tiene(UnJugador, edificio(Edificio, _)),
    edificioNecesarioSegunEdad(Edificio, Edad).

edificioNecesarioSegunEdad(herreria, edadDeLosCastillos).
edificioNecesarioSegunEdad(establo, edadDeLosCastillos).
edificioNecesarioSegunEdad(galeriaDeTiro, edadDeLosCastillos).
edificioNecesarioSegunEdad(castillo, edadImperial).
edificioNecesarioSegunEdad(universidad, edadImperial).

cantidadMinimaSegunRecurso(UnJugador, Recurso, CantidadMinima) :-
    produccionTotal(UnJugador, Produccion, Recurso),
    Produccion >= CantidadMinima.


