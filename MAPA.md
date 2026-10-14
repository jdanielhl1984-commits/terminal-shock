# MAPA DEL CÓDIGO — Terminal Shock

Guía para trabajar en `index.html` (≈2.450 líneas, 188 KB) **sin leerlo entero**.
Antes de tocar nada: busca aquí la sección, lee solo ese rango con `sed -n 'A,Bp' index.html`, y edita.

> ⚠️ Las líneas se mueven al editar. Si una cifra no cuadra, ancla por el marcador de
> sección (`grep -n "NOMBRE" index.html`) o regenera la tabla con `sh tools/mapa.sh`.

---

## 1. Cómo usar este mapa (para gastar menos tokens)

| Quiero… | Hago… |
|---|---|
| Ver una sección entera | `sed -n 'A,Bp' index.html` con el rango de la tabla |
| Saber en qué línea está una función | `sh tools/mapa.sh \| grep nombre` |
| Ver dónde se define y dónde se usa algo | `sh tools/mapa.sh grep nombre` |
| Regenerar el índice de funciones | `sh tools/mapa.sh` |
| Cambio pequeño | Dar a Daniel el texto exacto a buscar y el texto nuevo |
| Cambio grande | Dar el archivo completo revisado, nunca recortado |

Los dos bloques más pesados, **PERSONAJES** (~912–1138) y **MÚSICA** (~1555–1718), casi nunca cambian: no leerlos salvo que se toque eso.

---

## 2. Estructura del archivo (rangos de líneas)

| Líneas | Qué hay | Cuándo tocarlo |
|---|---|---|
| 1–10 | `<head>`: título, fuentes de Google | Casi nunca |
| 11–155 | **CSS** completo (variables en `:root`, overlays, HUD, mando táctil, animación de puerta) | Aspecto de menús, HUD, colores |
| 156–306 | **HTML**: overlays, canvas `#cv`, HUD (`#area #sub #prompt #toast`), mando `#pad` | Añadir pantallas o botones |
| 307 | `<script>` Three.js r128 (cdnjs) | — |
| 308–318 | Arranque: `RW=320 RH=240`, helpers `$ clamp rs angDiff pick`, detección táctil | — |
| 319–616 | **DATOS**: objetos `IT`, `ORDER`, `ICON`, documentos `DOCS`, **salas `ROOMS`** | Contenido: salas, notas, objetos |
| 617–911 | **MOTOR 3D**: texturas `tex()`, shader PS1 `ps1()`, materiales `MAT`, `objMesh()`, `initScene()`, `buildRoom()` | Look PS1, mobiliario, luces |
| 912–1138 | **PERSONAJES**: `loft()`, `paintHead/Hair/Cloth/Limb/Foot`, `CHAR_SPECS`, `buildChar()` | **Ropa, cara, pelo** |
| 1139–1285 | **PUERTAS**: `ROOM_STYLE`, `ROOM_CODE`, `doorSpec()`, `buildDoor()` | Puertas 3D |
| 1286–1381 | **ESTADO + AUDIO + ENTRADA**: globales, `freshState()`, `saveCP/loadCP`, `sfx()`, `say()`, `show()`, **teclado y mando** | Teclas, estado inicial, efectos de sonido |
| 1382–1554 | **MUNDO**: colisiones, enemigos `flow()`, **`updatePlayer()` (control tanque)**, `autoAim()`, `findInteract/action/useDoor/goRoom`, `shoot()`, boss | **Control, disparo, puertas, objetos** |
| 1555–1718 | **MÚSICA** WebAudio: `musicInit`, voces, `sfxDoor()`, `musicTick()` | Solo música |
| 1719–1809 | **ACTUALIZACIÓN**: `update(dt)` (enemigos, lucidez, daño), `die()`, `onEnter()`, `objective()` | Lógica por frame, eventos de guion |
| 1810–1870 | **FUSIONADORA** (minijuego) | Minijuego |
| 1871–1887 | **INVENTARIO** | Inventario |
| 1888–1917 | **FINAL + ARRANQUE**: `ending()`, `finale()`, `intro()`, `startGame()`, `newGame()` | Intro, finales |
| 1918–2143 | **ANIMACIÓN**: `JOINTS`, IK piernas, `G_WALK G_BACK G_TURN`, `animPlayer()`, `animZoe()`, `animEnemy()` | Cómo anda/corre/gira |
| 2144–2269 | **CÁMARAS FIJAS**: `camEval()`, `autoCams()`, `pickCam()` | Planos, cambios de cámara |
| 2270–2328 | **PUERTA EN PRIMERA PERSONA** (transición) | Transición de puerta |
| 2329–2395 | **RENDER**: `roomLights()`, `sync(dt)` (posiciona mallas, cámara, CRT) | Post-proceso, luces |
| 2396–2412 | **MONITOR DEL BRAZO** (ECG) | HUD de lucidez |
| 2413–2446 | **BUCLE**: `resize()`, `frame()`, `start()`, API de depuración `window.__TS` | Arranque, carga, pruebas |

---

## 3. "Quiero cambiar X, ¿dónde voy?"

| Tarea | Sección | Funciones clave |
|---|---|---|
| **Ropa/aspecto del protagonista** | PERSONAJES | `CHAR_SPECS` (línea ~1033), `paintCloth` (~985) |
| **Velocidad de andar / correr / girar** | MUNDO | `updatePlayer()` (~1397) |
| **Giro rápido 180°** | MUNDO + ENTRADA | `updatePlayer()` + variables `qt prevQT` (~1288) |
| **Apuntar y disparar** | MUNDO | `updatePlayer()`, `autoAim()` (~1409), `shoot()` (~1496) |
| **Cómo se mueve el muñeco al andar** | ANIMACIÓN | `G_WALK G_BACK G_TURN` (~1997), `animPlayer()` (~2049) |
| **Añadir una sala** | DATOS | `addRoom()` (~359), patrón de las salas existentes |
| **Añadir una nota/documento** | DATOS | `DOCS` (~346) |
| **Añadir un objeto recogible** | DATOS + MUNDO | `IT` (~320), `ICON` (~334), lógica en `search()`/`action()` |
| **Cambiar las cámaras de una sala** | DATOS + CÁMARAS | campo `cams` de la sala, `pickCam()` (~2244) |
| **Evento al entrar en una sala** | ACTUALIZACIÓN | `onEnter()` (~1778) |
| **Diálogo de un personaje** | varias | `say()` (~1341) |
| **Lucidez / barra / daño** | ACTUALIZACIÓN | `update()` (~1721) |
| **Los finales** | FINAL | `ending()` (~1889), `finale()` (~1894) |
| **Teclas y botones táctiles** | ENTRADA | handlers de teclado (~1356+), objeto `TK` (~1353) |
| **Colores globales / tema** | CSS | `:root` (~13) |

---

## 4. Cómo está pegado todo (lo que hay que entender antes de separar en módulos)

Todo el JavaScript vive dentro de **una sola función anónima** (`(()=>{ ... })();` en la línea 309). Dentro comparten ~15 variables globales. Las importantes:

| Variable | Qué es | Dónde nace |
|---|---|---|
| `S` | **El estado del juego** (sala, jugador, inventario, flags). Se guarda/carga como JSON | ~1287 |
| `MAT`, `TX` | Materiales y texturas de Three.js | ~719 / ~669 |
| `roomGroup`, `PM`, `ZM`, `EM`, `OM` | Mallas 3D: sala, jugador, Zoe, enemigos, objetos | ~834 |
| `camCur` | Cámara fija activa | ~2243 |
| `AC`, `MU` | Audio y música | ~1303 / ~1560 |
| `TK`, `H`, `keys` | Entrada (teclas pulsadas) | ~1353 |
| `camera`, `scene`, `renderer`, `rt` | Three.js base | en `initScene()` ~839 |

**Puente de depuración:** `window.__TS` (línea ~2434) expone estado y funciones para probar desde fuera (lo usa el arnés de pruebas). No borrarlo.

---

## 5. Pruebas sin abrir el navegador a mano

- El juego corre contra `window.__TS.step(dt, n)`, que avanza `n` frames de lógica sin depender del reloj real.
- Para comprobar un cambio de control o de sala, se simulan teclas con `window.__TS.TK` y se leen las posiciones resultantes.
- Hay un arnés con Playwright + Three.js r128 en el área temporal de la sesión; sirve para verificar que el juego arranca sin errores tras una edición.

---

## 6. Reglas de trabajo (de Daniel)

- Llamarle **Daniel**. Programador novato: explicar paso a paso, sin jerga.
- **Cambio pequeño:** darle el texto exacto a buscar y el texto por el que sustituirlo.
- **Cambio grande:** darle el archivo completo actualizado y revisado, nunca recortado.
- Respetar siempre el GDD. Si algo no encaja, preguntar antes de cambiarlo.

---

*Este mapa se regenera con `sh tools/mapa.sh`. Si cambias mucho la estructura, vuelve a correrlo y pega la tabla de la sección 2.*
