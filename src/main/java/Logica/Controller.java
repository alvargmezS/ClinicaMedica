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
        return persistenceC.getUsuarios();
    }

    public List<Medico> getMedicos() {
        return persistenceC.getMedicos();
    }

    public void crearMedico() {

        Medico medico = new Medico();

    }

    public void deleteUsuario(int id) {

        persistenceC.deleteUsuario(id);
    }

    public Usuario getUsuario(int id) {

        return persistenceC.getUsuario(id);
    }

    public void editUsuario(Usuario usu) {

        persistenceC.editUsuario(usu);
    }
}
