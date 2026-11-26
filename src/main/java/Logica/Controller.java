package Logica;

import persistence.PersistenceController;

import java.util.ArrayList;
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

    public boolean validIngreso(String usuario, String pass) {
    List<Usuario> usuarios = persistenceC.getUsuarios();

    if (usuarios == null || usuario == null || pass == null) {
        return false;
    }

    for (Usuario u : usuarios) {
        if (u.getNombre_usuario() != null && u.getNombre_usuario().equals(usuario)) {
            if (u.getPassword() != null && u.getPassword().equals(pass)) {
                return true; // Usuario y contraseña correctos, finaliza la búsqueda exitosamente
            }
            // Si el nombre coincide pero la contraseña no coincide, puedes salir directamente si los nombres son únicos
            return false;
        }
    }

    System.out.println("El usuario no existe");
    return false;
}
}
