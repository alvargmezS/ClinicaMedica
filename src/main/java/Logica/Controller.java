package Logica;

import persistence.PersistenceController;

import java.util.Date;
import java.util.List;

public class Controller {

    PersistenceController persistenceC = new PersistenceController();

    public void crearUsuario(String nombreUsuario, String pass, String rol){

        Usuario usuario = new Usuario();
        usuario.setNombre_usuario(nombreUsuario);
        usuario.setPassword(PasswordUtils.hashPassword(pass));
        usuario.setRol(rol);

        persistenceC.crearUsuario(usuario);
    }

    public List<Usuario> getUsuarios() {
        return persistenceC.getUsuarios();
    }

    public List<Medico> getMedicos() {
        return persistenceC.getMedicos();
    }

    public void crearMedico(String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                            String especialidad, String horaInicio, String horaFin, String nombreUsuario, String pass) {

        // 1. Crear el objeto Horario
        Horario horario = new Horario();
        horario.setHora_inicio(horaInicio);
        horario.setHora_fin(horaFin);

        // 2. Crear el objeto Usuario con rol "Medico" y contraseña hasheada
        Usuario usuario = new Usuario();
        usuario.setNombre_usuario(nombreUsuario);
        usuario.setPassword(PasswordUtils.hashPassword(pass));
        usuario.setRol("Medico");

        // 3. Crear el objeto Médico
        Medico med = new Medico();
        med.setDni(dni);
        med.setNombre(nombre);
        med.setApellido(apellido);
        med.setDireccion(direccion);
        med.setTelefono(telefono);
        med.setFecha_nacimiento(fechaNac);
        med.setEspecialidad(especialidad);

        // 4. Persistir todo mediante el controlador de persistencia
        persistenceC.crearMedico(med, horario, usuario);
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
                if (PasswordUtils.checkPassword(pass, u.getPassword())) {
                    // Si la contraseña en BD estaba en texto plano, se migra automáticamente a BCrypt
                    if (!PasswordUtils.isHashed(u.getPassword())) {
                        u.setPassword(PasswordUtils.hashPassword(pass));
                        persistenceC.editUsuario(u);
                    }
                    return true;
                }
                return false;
            }
        }

        System.out.println("El usuario no existe");
        return false;
    }
}
