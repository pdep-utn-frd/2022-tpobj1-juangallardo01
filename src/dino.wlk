import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Robot Game")
		game.addVisual(fondo)
		game.addVisual(meteorito)
		game.addVisual(robot)
		game.addVisual(reloj)
		game.addVisual(naveespacial)
		game.boardGround("FondoFinal.jpg")
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(robot,{ obstaculo => obstaculo.chocar()})
		
		
	} 
	
	method    iniciar(){
		robot.iniciar()
		reloj.iniciar()
		meteorito.iniciar()
		naveespacial.iniciar()
	}
	
	method jugar(){
		if (robot.estaVivo()) 
			robot.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		meteorito.detener()
		reloj.detener()
		robot.morir()
		naveespacial.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "JUEGO TERMINADO"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object meteorito {
	 
	const posicionInicial = game.at(game.width()-1,fondo.position().y())
	var position = posicionInicial

	method image() = "meteorito.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverMeteorito",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverMeteorito")
	}
}

object fondo{
	
	method position() = game.origin().up(1)
	
	method image() = "fondo.png"
}


object robot {
	var vivo = true
	var position = game.at(1,fondo.position().y())
	
	method image() = "robot.png"
	method position() = position
	
	method saltar(){
		if(position.y() == fondo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡SOBRECALENTAMIENTO!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

object naveespacial {
	 
	const posicionInicial = game.at(game.width()-5,fondo.position().y())
	var position = posicionInicial

	method image() = "naveespacial.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverNaveespacial",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverNaveespacial")
	}
}