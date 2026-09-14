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
}