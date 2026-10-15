# 🎯 Adivina el Número - Práctica Móviles 2026

Aplicación interactiva desarrollada en Flutter para la asignatura **Desarrollo de Aplicaciones para Dispositivos Móviles** de la **Universidad del Valle**, bajo la orientación de la **Mg. Diana Marcela Ramirez Rodriguez**.

---

## 📌 Contexto de la Aplicación

El juego genera de forma aleatoria un número secreto dentro de un rango determinado. El usuario debe adivinar el número antes de que se agoten sus intentos. La aplicación proporciona pistas inteligentes ("más alto", "más bajo" y pistas sobre si el número es par o impar) y gestiona el estado en tiempo real con animaciones fluidas y retroalimentación interactiva.

---

## 🚀 Modificaciones Realizadas

### 🟢 Nivel 1 - Básico
1. **Tema visual personalizado:** Se configuró una paleta basada en `Colors.teal`, `Colors.amber` y `Colors.blueGrey`, con `AppBar` estilizado, botones con elevación y sombras suaves.
2. **Mensajes y emojis dinámicos:** Se implementaron textos interactivos y emojis expresivos (🎯, 🚀, 💡, 🏆, 💥, 📈, 📉) que enriquecen la experiencia del usuario.
3. **Control dinámico de intentos:** Ajuste de oportunidades según el nivel de dificultad seleccionado.

### 🟡 Nivel 2 - Intermedio
4. **Botón de Pista:** Permite al usuario consultar si el número secreto es **par o impar**, restando 1 intento adicional como penalización estratégica.
5. **Indicador de Progreso Visual (`LinearProgressIndicator`):** Muestra el desgaste de los intentos y cambia automáticamente de color:
   - **Verde:** Más del 50% de intentos disponibles.
   - **Amarillo/Ámbar:** Entre el 25% y el 50% de intentos restantes.
   - **Rojo:** Menos del 25% de intentos (zona de peligro).
6. **Historial de Intentos (`ListView`):** Lista desplazable con los intentos previos, indicando mediante tarjetas de color si el número ingresado fue demasiado alto o demasiado bajo.

### 🔴 Nivel 3 - Avanzado
7. **Animaciones Integradas:**
   - `ScaleTransition` con efecto elástico (`Curves.elasticOut`) en el icono central del estado del juego.
   - `AnimatedContainer` para redimensionar y animar el contenedor del mensaje de retroalimentación suavemente.
8. **Sistema de Puntuación y Récord:** Guarda y muestra en pantalla el récord del jugador (menor cantidad de intentos con los que logró adivinar el número).
9. **Modos de Dificultad (`SegmentedButton`):**
   - **Modo Fácil:** Rango de 1 a 50 con 7 intentos.
   - **Modo Medio:** Rango de 1 a 100 con 5 intentos.
   - **Modo Difícil:** Rango de 1 a 200 con 4 intentos.

---

## 📝 Respuestas al Cuestionario Teórico (Paso 4)

### 1. ¿Qué hace la función `main` y por qué es importante?
La función `void main()` es el punto de entrada de la aplicación en Dart/Flutter. Ejecuta `runApp(const AdivinaNumeroApp())`, la cual monta el widget raíz en el árbol de widgets e inicializa el ciclo de vida del renderizado en el dispositivo.

### 2. ¿Cuál es la diferencia entre `MyApp` (un `StatelessWidget`) y `MyHomePage` (un `StatefulWidget`)?
- **`StatelessWidget`:** Es inmutable; su apariencia no depende de cambios internos a lo largo del tiempo. Se usa para configurar el tema global, fuentes y rutas.
- **`StatefulWidget`:** Es dinámico y mutable. Posee una clase de estado asociada (`State`) que retiene variables que cambian durante la partida (`_numeroSecreto`, `_intentosRestantes`, historial) y redibuja la interfaz ante la interacción del usuario.

### 3. ¿Qué papel juega `setState` en las funciones `_iniciarJuego` y `_verificarAdivinanza`?
`setState` informa al motor de Flutter que los datos internos del widget han cambiado, lo que dispara una nueva llamada al método `build()` para refrescar la interfaz gráfica con los nuevos valores calculados.

### 4. ¿Cómo funciona la validación de entrada en `_verificarAdivinanza`?
Valida dos condiciones antes de procesar el juego:
1. Que el campo no esté vacío (`texto.isEmpty`).
2. Que sea un entero válido mediante `int.tryParse(texto)` y que se encuentre estrictamente dentro del rango permitido (ej. $1 \le x \le RangoMaximo$). De no cumplirse, lanza un `SnackBar` informativo sin descontar intentos.

### 5. ¿Qué propósito tiene `TextEditingController` y por qué se debe liberar en `dispose`?
Permite escuchar, leer y limpiar el contenido del campo de texto (`TextField`). Debe liberarse con `_controller.dispose()` en el método `dispose()` para evitar fugas de memoria (*memory leaks*).

### 6. ¿Cómo se organiza la interfaz usando `Column` y qué otros widgets de layout se utilizan?
`Column` dispone los elementos en sentido vertical (eje Y). Se complementa con:
- `SafeArea`: Para respetar las áreas seguras del notch y barras de navegación.
- `SingleChildScrollView`: Para evitar desbordamientos de pantalla (`overflow`) cuando aparece el teclado en pantalla.
- `Row`: Para alinear elementos en horizontal (iconos, textos, botones paralelos).
- `SizedBox` y `Container`: Para márgenes, rellenos y decoraciones.

---

## 📊 Tabla de Identificación de Tipos de Widgets

| Categoría | Widgets Clave | Función Principal |
| :--- | :--- | :--- |
| **Estructurales** | `MaterialApp`, `Scaffold`, `SafeArea`, `AppBar` | Definen la arquitectura visual de Material Design y los márgenes seguros. |
| **Layout y Organización** | `Column`, `Row`, `SingleChildScrollView`, `SizedBox`, `Center` | Distribuyen los componentes vertical y horizontalmente, controlando el scroll y el espaciado. |
| **Visuales y Contenido** | `Text`, `Icon`, `Container`, `Chip`, `Divider` | Renderizan información, etiquetas, bordes, sombras y elementos gráficos. |
| **Interacción y Entrada** | `TextField`, `ElevatedButton`, `OutlinedButton`, `IconButton`, `SegmentedButton` | Capturan la entrada de datos por teclado, selecciones de dificultad y clics del usuario. |
| **Animación** | `ScaleTransition`, `AnimatedContainer`, `CurvedAnimation` | Proporcionan transiciones elásticas y cambios fluidos en la UI. |
| **Feedback y Notificaciones** | `LinearProgressIndicator`, `SnackBar`, `ScaffoldMessenger` | Informan visualmente el estado de los intentos y muestran avisos flotantes temporales. |

---

## 🛠️ Tecnologías Utilizadas

- **Flutter SDK:** $\ge 3.0.0$
- **Dart:** $\ge 3.0.0$
- **Diseño:** Material Design 3

---

## 💻 Instrucciones para Ejecutar el Proyecto

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/maoyinggomez/adivina-el-numero-app-m.git
   cd adivina-el-numero-app-m
   ```

2. Descargar las dependencias:
   ```bash
   flutter pub get
   ```

3. Correr la aplicación en un emulador o dispositivo conectado:
   ```bash
   flutter run
   ```