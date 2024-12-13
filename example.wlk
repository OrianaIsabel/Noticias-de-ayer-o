object multimedia {
  const property fecha = new Date()
  const periodistas = []

  method periodistasAlDia() = periodistas.filter({p => p.esReciente() && p.publicoEnLaSemana()})
}

class Noticia {
  const property publicacion = new Date()
  const property autor
  const property importancia
  const property titulo
  const desarrollo

  method esImportante() = importancia >= 8

  method esReciente() = publicacion.day().between(multimedia.fecha.day() - 3, multimedia.fecha.day())

  method puedeSerCopado()

  method esCopado() = self.esImportante() && self.esReciente() && self.puedeSerCopado()

  method esSensacionalista() = titulo.contains("espectacular") || titulo.contains("grandioso") || titulo.contains("increible")

  method esVago() = desarrollo.size() < 100

  method bienEscrita() = titulo.words().size() >= 2 && !(desarrollo.isEmpty())
}

class Comun inherits Noticia {
  const property links = []

  override method puedeSerCopado() = links.size() >= 2
}

class Chivo inherits Noticia {
  const property pagado

  override method puedeSerCopado() = pagado > 2000000

  override method esVago() = true
}

class Reportaje inherits Noticia {
  const property objetivo

  override method puedeSerCopado() = self.letras().size().odd()

  method letras() = objetivo.words().sum({p => p.size()})

  override method esSensacionalista() = super() || titulo.contains("Dibu Martinez")
}

class Cobertura inherits Noticia {
  const property noticias = []

  override method puedeSerCopado() = noticias.all({n => n.esCopado()})
}

class Periodista {
  const property ingreso = new Date()
  const property preferencia
  const publicadas = []

  method prefiere(noticia) = preferencia.acepta(noticia)

  method aceptaNoPreferida() = publicadas.filter({n => !(self.prefiere(n))}).size() < 2

  method puedePublicar(noticia) = self.prefiere(noticia) || self.aceptaNoPreferida()

  method publicar(noticia) {
    if (self.puedePublicar(noticia))
      publicadas.add(noticia)
  }

  method esReciente() = ingreso.between(multimedia.fecha().minusYears(1), multimedia.fecha())

  method publicoEnLaSemana() = publicadas.any({n => n.publicacion().between(multimedia.fecha().minusDays(7), multimedia.fecha())})
}

const joseDeZer = new Periodista(preferencia = zer)

object zer {
  method acepta(noticia) = noticia.titulo().head() == 'T'
}

object copadas {
  method acepta(noticia) = noticia.esCopado()
}

object sensacionalistas {
  method acepta(noticia) = noticia.esSensacionalista()
}

object vagas {
  method acepta(noticia) = noticia.esVago()
}