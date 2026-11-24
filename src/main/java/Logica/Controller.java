package Logica;

import persistence.PersistenceController;

import java.util.List;

public class Controller {

    PersistenceController persistenceC = new PersistenceController();

    public void crearUsuario(String nombreUsuario, String pass, String rol){

        Usuario usuario = new Usuario();
        usuario.setNombre_usuario(nombreUsuario);
        usuario.setPassword(pass);
        usuario.setRol(rol);

        persistenceC.crearUsuario(usuario);
    }

    public List<Usuario> getUsuarios() {
        return persistenceC.getUsuario();
    }
}
