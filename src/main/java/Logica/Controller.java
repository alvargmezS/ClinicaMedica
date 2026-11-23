package Logica;

import Persistence.PersistenceController;

public class Controller {

    PersistenceController persistenceC = new PersistenceController();

    public void crearUsuario(int id,String nombreUsuario, String pass, String rol){

        Usuario usuario = new Usuario(id,nombreUsuario,pass,rol);
        persistenceC.crearUsuario(usuario);
    }
}
