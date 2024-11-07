// -----------------------
// ----- PERSONAJES ------
// -----------------------

class Personaje {
  const property fuerza = 100
  const property inteligencia = 100
  var property rol    // Cada personaje tiene un único rol, pero, si se aburren, pueden cambiarlo por otro haciendo el trámite correspondiente.


  method potencialOfensivo() = fuerza * 10 + rol.potencialOfensivoExtra()
  
  method esGroso() = self.esInteligente() || self.esGrosoParaSuRol()

  method esInteligente()                          // metodo abstracto y luego la subclases me pisan este metodo

  method esGrosoParaSuRol() = rol.esGroso(self)   // uso como parametro la persona, asi puedo usar sus atributos o metodos --> LE PASO LA PELOTA AL ROL, JUEGUE!!
                                                  // "el personaje conoce al rol, PERO el rol no conoce al personaje" (por eso lo mando como parametro)
}

class Humano inherits Personaje {
  override method esInteligente() = inteligencia > 50
}

class Orco inherits Personaje {
  override method potencialOfensivo() = super() * 1.1  // En el caso particular de los orcos, producto de su brutalidad innata, su potencial ofensivo es un 10% más.
  override method esInteligente() = false              // Los orcos nunca son inteligentes
}


// -----------------------
// ------- ROLES ---------
// -----------------------


object guerrero {
  method potencialOfensivoExtra() = 100
  method esGroso(personaje) = personaje.fuerza() > 50   // Personaje.fuerza() > 50 ---> ESTO ESTARIA MAL --> "el personaje conoce al rol, PERO el rol no conoce al personaje" (por eso lo mando como parametro)
}

class Cazador {     // lo hago una class --> porque asi cada cazador que yo cree va a tener su propia mascota!!
  var mascota       // cada cazador va a tener una mascota propia
  
  method potencialOfensivoExtra() = mascota.potencialOfensivoMascota()
  method esGroso(personaje) = mascota.esLongeva() 
}

object brujo {
  method potencialOfensivoExtra() = 0   // no da ningun potencia extra  
  method esGroso(personaje) = true      // el brujo SIEMPRE es groso. Ojo NO OLVIDAR poner el parametro en el metodo para seguir cumplimiento con el polimorfismo
}

class Mascota {
  const fuerza
  const edad
  const tieneGarras 
  
  method potencialOfensivoMascota() = if(tieneGarras) fuerza * 2 else fuerza  
  method esLongeva() = edad > 10 
}

// Por ejemplo
// const ezequiel = new Orco(rol = new Cazador (mascota = new Mascota (fuerza = ??, edad = ??, tieneGarras = true)))

// -----------------------------
// ------- LOCALIDADES ---------
// -----------------------------

class Ejercito {
  const property miembros = []

  method potencialOfensivo() = miembros.sum({miembro => miembro.potencialOfensivo()})  

  method invadir(zona) {                                        // puede ir desmenuzando el problema... (y luego voy modelando cada cosa)
    if(zona.potencialDefensivo() < self.potencialOfensivo()){ 
      zona.esOcupadaPor(self)
    }
  }

  method dividirEnDos() {
    miembros.sortedBy({uno, otro => uno.potencialOfensivo() > otro.potencialOfensivo()}).take(10)   // agarro los primeros 10 miembros con mayor potencial ofensivo
  }

}


class Zona {
  var habitantes = []

  method potencialDefensivo() = habitantes.sum({habitante => habitante.potencialOfensivo()})  

  method esOcupadaPor(ejercito) { habitantes = ejercito.miembros() }  // ser ocupado --> significa que el ejercito pise los habitantes de la zona 
 

}

class Aldea inherits Zona {
  const maxDeHabitantes = 50   // Las aldeas tienen una cantidad máxima de habitantes y esto va a ser el pie para modificar el esOcupadaPor abajo....

  override method esOcupadaPor(ejercito) { 
    if(ejercito.miembros().size() > maxDeHabitantes) {
      ejercito.dividirEnDos()
    
    }else super(ejercito)
  }

}

class Ciudad inherits Zona {   // sólo las ciudades pueden contener cualquier cantidad de personajes.
  override method potencialDefensivo() = super() + 300 
}

