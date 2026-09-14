// -- Parte 1 --
void main() {
  // 1. Declaración de las variables de la ficha digital
  String nombre = "Carlos"; 
  int edad = 22;           
  double promedio = 4.3;    
  bool matriculaActiva = true; 

  // 2. Imprimir la ficha completa
  print("=== FICHA DIGITAL DEL ESTUDIANTE ===");
  print("Nombre: $nombre");
  print("Edad: $edad años");
  print("Promedio: $promedio");
  print("Estado de matrícula (Activa): $matriculaActiva");
  print("====================================");
// -- Parte 2 --
  String? apodo; // El '?' indica que esta variable puede ser nula.

  // Lógica para mostrar el apodo o un mensaje alternativo
  if (apodo != null) {
    print("Apodo del estudiante: $apodo");
  } else {
    print("El estudiante no tiene un apodo registrado.");
  }
  
  /*
   Justificación:
   La variable 'apodo' debe ser nullable (String?) porque en la vida real 
   no es un dato obligatorio. En cambio, las variables de la Parte 1 (nombre,edad) no pueden ser nulas porque una ficha de matrícula quedaría incompleta y el sistema no podría funcionar correctamente sin esa información básica.

   Respuesta a "Para pensar":
   Si usas el operador '!' sobre una variable que es 'null' (por ejemplo, 
   escribiendo 'print(apodo!);''), el error aparece al ejecutar el código (en tiempo de ejecución), no al escribirlo. El operador '!' le dice a Dart: 
   "confía en mí, sé que esto no es nulo". Como el editor confía en ti, no marca 
   error de sintaxis, pero cuando el programa corre y se estrella contra el 'null',el sistema colapsa.
  */
// -- Parte 3 --
  bool apruebaMateria(double nota) => nota >= 3.0;

  // 1. Función para calcular el promedio de un listado de notas
  double calcularPromedio(List<double> notas) {
    if (notas.isEmpty) {
      return 0.0; 
    }
    
    double suma = 0;
    for (double nota in notas) {
      suma += nota;
    }
    return suma / notas.length;
  }

  // Ejecución de las funciones
  print("\n=== RENDIMIENTO ACADÉMICO ===");
  double notaEstudiante = 3.8;
  print("¿Aprueba la materia con $notaEstudiante? ${apruebaMateria(notaEstudiante) ? 'Sí' : 'No'}");

  List<double> notasSemestre = [4.0, 3.5, 4.5, 2.8];
  print("El promedio del semestre es: ${calcularPromedio(notasSemestre)}");
  print("====================================");

  /*
   Respuesta a "Para pensar":
   Si la lista de notas llega vacía, la función calcularPromedio fallaría porque intentaría dividir la suma entre cero (ya que no hay notas). Eso hace que el código tire un error raro o se reviente. Para manejarlo, le puse un 'if' al principio: si la lista está vacía ('notas.isEmpty'), devuelve 0.0 de una vez y así no hace la división.
  */
  // -- Parte 4 --
  
  // 1. Lista de asistentes (List: permite repetidos)
  List<String> asistencia = ["Ana", "Juan", "Pedro", "Ana"]; 
  
  // 2. Conjunto de lenguajes (Set: no permite repetidos)
  Set<String> lenguajes = {"Dart", "Python", "JavaScript"};
  
  // 3. Relación estudiante -> nota (Map: clave-valor)
  Map<String, double> notasAlumnos = {
    "Ana": 4.5,
    "Juan": 3.8,
    "Pedro": 4.0
  };

  print("\n=== COLECCIONES ===");
  print("Asistencia (con repetidos): $asistencia");
  print("Lenguajes que sé: $lenguajes");
  print("Nota de Juan: ${notasAlumnos["Juan"]}");
  print("====================================");

  /*
   Justificación de las colecciones:
   - Usé List para la asistencia porque a veces la gente se registra dos veces por error y la lista normal sí deja guardar repetidos.
   - Usé Set para los lenguajes porque no tiene sentido decir que sé "Dart" dos veces. El Set me ayuda a que no haya basura repetida.
   - Usé Map para las notas porque funciona como un diccionario. Es muy fácil buscar el nombre de alguien y que de una me tire la nota.

   Respuesta a "Para pensar":
   Si usara una List para los lenguajes en vez de un Set, el sistema guardaría el mismo lenguaje varias veces. Hice la prueba metiendo "Java" dos veces en una List y me imprimió las dos, pero en el Set solo me dejó una.
  */
  
  // -- Parte 5 --
  
  // Problema A: Clasificar notas
  List<double> notasCurso = [2.5, 3.2, 4.8, 5.0, 1.5, 4.0];
  int reprobados = 0;
  int aprobados = 0;
  int sobresalientes = 0;

  for (double nota in notasCurso) {
    if (nota < 3.0) {
      reprobados++;
    } else if (nota >= 3.0 && nota <= 4.5) {
      aprobados++;
    } else {
      sobresalientes++;
    }
  }

  print("\n=== CLASIFICACIÓN DE NOTAS ===");
  print("Reprobados: $reprobados");
  print("Aprobados: $aprobados");
  print("Sobresalientes: $sobresalientes");

  // Problema B: Bloqueo por intentos de contraseña
  String claveCorrecta = "admin123";
  String claveIngresada = "fallo"; // Simulamos que el usuario mete una clave mala
  int intentos = 0;
  int maxIntentos = 3;

  print("\n=== SISTEMA DE LOGIN ===");
  while (intentos < maxIntentos && claveIngresada != claveCorrecta) {
    intentos++;
    print("Intento $intentos fallido.");
    // Aquí en un programa real pediríamos la clave de nuevo
  }

  if (intentos == maxIntentos) {
    print("¡Acceso bloqueado! Agotaste los intentos.");
  }
  print("====================================");

  /*
   Respuesta a "Para pensar":
   El problema A se resuelve mejor con un 'for' porque ya sabemos de entrada 
   cuántas notas hay en la lista, entonces el ciclo solo da el número exacto 
   de vueltas para revisar cada nota. 
   
   En cambio, el problema B es mejor con un 'while' porque no sabemos 
   en qué momento el usuario va a meter la contraseña bien. El ciclo 
   se tiene que repetir *mientras* la clave sea incorrecta y todavía le 
   queden intentos.
  */
}