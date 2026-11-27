package Logica;

import persistence.PersistenceController;

import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

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

    public Medico getMedico(int id) {
        return persistenceC.getMedico(id);
    }

    public List<Medico> buscarMedicos(String nombre, String especialidad) {
        List<Medico> todos = persistenceC.getMedicos();
        if (todos == null) return new ArrayList<>();

        boolean filtrarNombre = (nombre != null && !nombre.trim().isEmpty());
        boolean filtrarEsp = (especialidad != null && !especialidad.trim().isEmpty() && !especialidad.equalsIgnoreCase("todas"));

        if (!filtrarNombre && !filtrarEsp) {
            return todos;
        }

        String nomNorm = filtrarNombre ? nombre.trim().toLowerCase() : "";
        String espNorm = filtrarEsp ? especialidad.trim().toLowerCase() : "";

        List<Medico> resultado = new ArrayList<>();
        for (Medico m : todos) {
            boolean coincideNombre = true;
            if (filtrarNombre) {
                String nomCompleto = ((m.getNombre() != null ? m.getNombre() : "") + " " + (m.getApellido() != null ? m.getApellido() : "")).toLowerCase();
                coincideNombre = nomCompleto.contains(nomNorm);
            }

            boolean coincideEsp = true;
            if (filtrarEsp) {
                coincideEsp = (m.getEspecialidad() != null && m.getEspecialidad().toLowerCase().contains(espNorm));
            }

            if (coincideNombre && coincideEsp) {
                resultado.add(m);
            }
        }
        return resultado;
    }

    public List<String> getEspecialidades() {
        List<Medico> todos = persistenceC.getMedicos();
        Set<String> setEsp = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
        if (todos != null) {
            for (Medico m : todos) {
                if (m.getEspecialidad() != null && !m.getEspecialidad().trim().isEmpty()) {
                    setEsp.add(m.getEspecialidad().trim());
                }
            }
        }
        return new ArrayList<>(setEsp);
    }

    public void eliminarMedico(int id) {
        persistenceC.deleteMedico(id);
    }

    public void editMedico(int idMedico, String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                           String especialidad, String horaInicio, String horaFin, int idUsuario) {

        Medico med = persistenceC.getMedico(idMedico);
        if (med == null) {
            throw new IllegalArgumentException("El médico a modificar no existe.");
        }

        med.setDni(dni);
        med.setNombre(nombre);
        med.setApellido(apellido);
        med.setDireccion(direccion);
        med.setTelefono(telefono);
        med.setFecha_nacimiento(fechaNac);
        med.setEspecialidad(especialidad);

        // Actualizar o crear horario
        Horario hor = med.getHorarioMedico();
        if (hor == null) {
            hor = new Horario();
        }
        hor.setHora_inicio(horaInicio);
        hor.setHora_fin(horaFin);

        // Actualizar usuario asociado
        if (idUsuario > 0) {
            Usuario u = persistenceC.getUsuario(idUsuario);
            med.setUsuarioMedico(u);
        } else if (idUsuario == 0) {
            med.setUsuarioMedico(null);
        }

        persistenceC.editMedico(med, hor);
    }

    public List<Usuario> getUsuariosSinMedico() {
        List<Usuario> todosUsuarios = persistenceC.getUsuarios();
        List<Medico> todosMedicos = persistenceC.getMedicos();

        if (todosUsuarios == null) return new ArrayList<>();
        if (todosMedicos == null || todosMedicos.isEmpty()) return todosUsuarios;

        Set<Integer> idsUsuariosOcupados = new HashSet<>();
        for (Medico m : todosMedicos) {
            if (m.getUsuarioMedico() != null) {
                idsUsuariosOcupados.add(m.getUsuarioMedico().getId_usuario());
            }
        }

        List<Usuario> usuariosDisponibles = new ArrayList<>();
        for (Usuario u : todosUsuarios) {
            if (!idsUsuariosOcupados.contains(u.getId_usuario())) {
                usuariosDisponibles.add(u);
            }
        }
        return usuariosDisponibles;
    }

    /**
     * Devuelve los usuarios sin médico asignado MÁS el usuario actual del médico en edición.
     */
    public List<Usuario> getUsuariosDisponiblesParaEditar(Medico medicoActual) {
        List<Usuario> disponibles = getUsuariosSinMedico();
        if (medicoActual != null && medicoActual.getUsuarioMedico() != null) {
            Usuario usuActual = medicoActual.getUsuarioMedico();
            boolean yaEsta = false;
            for (Usuario u : disponibles) {
                if (u.getId_usuario() == usuActual.getId_usuario()) {
                    yaEsta = true;
                    break;
                }
            }
            if (!yaEsta) {
                disponibles.add(0, usuActual);
            }
        }
        return disponibles;
    }

    public void deleteUsuario(int id) {

        persistenceC.deleteUsuario(id);
    }

    public Usuario getUsuario(int id) {
        return persistenceC.getUsuario(id);
    }

    public void editUsuario(Usuario usu) {
        // Asegurar que si la contraseña no estaba hasheada o fue modificada en texto plano, se asegure
        if (usu.getPassword() != null && !PasswordUtils.isHashed(usu.getPassword())) {
            usu.setPassword(PasswordUtils.hashPassword(usu.getPassword()));
        }
        persistenceC.editUsuario(usu);
    }

    public void editUsuarioConPassword(int id, String nombreUsuario, String nuevaPass, String rol) {
        Usuario usu = persistenceC.getUsuario(id);
        if (usu != null) {
            usu.setNombre_usuario(nombreUsuario);
            usu.setRol(rol);
            if (nuevaPass != null && !nuevaPass.trim().isEmpty()) {
                usu.setPassword(PasswordUtils.hashPassword(nuevaPass));
            }
            persistenceC.editUsuario(usu);
        }
    }

    public void crearMedico(String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                            String especialidad, String horaInicio, String horaFin, String nombreUsuario, String pass, String rol) {

        Horario horario = new Horario();
        horario.setHora_inicio(horaInicio);
        horario.setHora_fin(horaFin);

        Usuario usuario = new Usuario();
        usuario.setNombre_usuario(nombreUsuario);
        usuario.setPassword(PasswordUtils.hashPassword(pass));
        usuario.setRol((rol != null && !rol.trim().isEmpty()) ? rol : "Medico");

        Medico med = new Medico();
        med.setDni(dni);
        med.setNombre(nombre);
        med.setApellido(apellido);
        med.setDireccion(direccion);
        med.setTelefono(telefono);
        med.setFecha_nacimiento(fechaNac);
        med.setEspecialidad(especialidad);

        persistenceC.crearMedico(med, horario, usuario);
    }

    public void crearMedicoConUsuarioExistente(String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                                              String especialidad, String horaInicio, String horaFin, int idUsuario) {

        Usuario usuarioExistente = persistenceC.getUsuario(idUsuario);
        if (usuarioExistente == null) {
            throw new IllegalArgumentException("El usuario seleccionado no existe.");
        }

        Horario horario = new Horario();
        horario.setHora_inicio(horaInicio);
        horario.setHora_fin(horaFin);

        Medico med = new Medico();
        med.setDni(dni);
        med.setNombre(nombre);
        med.setApellido(apellido);
        med.setDireccion(direccion);
        med.setTelefono(telefono);
        med.setFecha_nacimiento(fechaNac);
        med.setEspecialidad(especialidad);

        persistenceC.crearMedicoConUsuarioExistente(med, horario, usuarioExistente);
    }

    public boolean comprobarIngreso(String usuario, String pass) {
        List<Usuario> usuarios = persistenceC.getUsuarios();

        if (usuarios == null || usuario == null || pass == null) {
            return false;
        }

        for (Usuario u : usuarios) {
            if (u.getNombre_usuario() != null && u.getNombre_usuario().equals(usuario)) {
                if (PasswordUtils.checkPassword(pass, u.getPassword())) {
                    if (!PasswordUtils.isHashed(u.getPassword())) {
                        u.setPassword(PasswordUtils.hashPassword(pass));
                        persistenceC.editUsuario(u);
                    }
                    return true;
                }
                return false;
            }
        }
        return false;
    }

    public Usuario obtenerUsuario(String usuario, String pass) {
        List<Usuario> usuarios = persistenceC.getUsuarios();

        if (usuarios == null || usuario == null || pass == null) {
            return null;
        }

        for (Usuario u : usuarios) {
            if (u.getNombre_usuario() != null && u.getNombre_usuario().equals(usuario)) {
                if (PasswordUtils.checkPassword(pass, u.getPassword())) {
                    if (!PasswordUtils.isHashed(u.getPassword())) {
                        u.setPassword(PasswordUtils.hashPassword(pass));
                        persistenceC.editUsuario(u);
                    }
                    return u;
                }
                return null;
            }
        }

        System.out.println("El usuario no existe");
        return null;
    }

    public boolean validIngreso(String usuario, String pass) {
        return obtenerUsuario(usuario, pass) != null;
    }

    // --- Métodos de Gestión de Pacientes ---
    public List<Paciente> getPacientes() {
        return persistenceC.getPacientes();
    }

    public Paciente getPaciente(int id) {
        return persistenceC.getPaciente(id);
    }

    public List<Paciente> buscarPacientes(String termino) {
        List<Paciente> todos = persistenceC.getPacientes();
        if (todos == null) return new ArrayList<>();

        if (termino == null || termino.trim().isEmpty()) {
            return todos;
        }

        String norm = termino.trim().toLowerCase();
        List<Paciente> resultado = new ArrayList<>();
        for (Paciente p : todos) {
            String nomCompleto = ((p.getNombre() != null ? p.getNombre() : "") + " " + (p.getApellido() != null ? p.getApellido() : "")).toLowerCase();
            String dni = (p.getDni() != null) ? p.getDni().toLowerCase() : "";
            String seguro = (p.getSeguro_medico() != null) ? p.getSeguro_medico().toLowerCase() : "";

            if (nomCompleto.contains(norm) || dni.contains(norm) || seguro.contains(norm)) {
                resultado.add(p);
            }
        }
        return resultado;
    }

    public void eliminarPaciente(int id) {
        persistenceC.eliminarPaciente(id);
    }

    public Paciente crearPaciente(String dni, String nombre, String apellido, String telefono, String direccion, Date fechaNac, String seguro, String grupoSangre) {
        Paciente pac = new Paciente();
        pac.setDni(dni);
        pac.setNombre(nombre);
        pac.setApellido(apellido);
        pac.setTelefono(telefono);
        pac.setDireccion(direccion);
        pac.setFecha_nacimiento(fechaNac);
        pac.setSeguro_medico(seguro);
        pac.setGrupo_sangre(grupoSangre);
        persistenceC.crearPaciente(pac);
        return pac;
    }

    // --- Métodos de Gestión de Administrativos ---
    public List<Administrativo> getAdministrativos() {
        return persistenceC.getAdministrativos();
    }

    public Administrativo getAdministrativo(int id) {
        return persistenceC.getAdministrativo(id);
    }

    public void eliminarAdministrativo(int id) {
        persistenceC.deleteAdministrativo(id);
    }

    public List<Usuario> getUsuariosSinAdministrativo() {
        List<Usuario> todosUsuarios = persistenceC.getUsuarios();
        List<Administrativo> todosAdmins = persistenceC.getAdministrativos();

        if (todosUsuarios == null) return new ArrayList<>();
        if (todosAdmins == null || todosAdmins.isEmpty()) return todosUsuarios;

        Set<Integer> idsUsuariosOcupados = new HashSet<>();
        for (Administrativo a : todosAdmins) {
            if (a.getUsuarioAdministrativo() != null) {
                idsUsuariosOcupados.add(a.getUsuarioAdministrativo().getId_usuario());
            }
        }

        List<Usuario> usuariosDisponibles = new ArrayList<>();
        for (Usuario u : todosUsuarios) {
            if (!idsUsuariosOcupados.contains(u.getId_usuario())) {
                usuariosDisponibles.add(u);
            }
        }
        return usuariosDisponibles;
    }

    public List<Usuario> getUsuariosDisponiblesParaEditarAdministrativo(Administrativo adminActual) {
        List<Usuario> disponibles = getUsuariosSinAdministrativo();
        if (adminActual != null && adminActual.getUsuarioAdministrativo() != null) {
            Usuario usuActual = adminActual.getUsuarioAdministrativo();
            boolean yaEsta = false;
            for (Usuario u : disponibles) {
                if (u.getId_usuario() == usuActual.getId_usuario()) {
                    yaEsta = true;
                    break;
                }
            }
            if (!yaEsta) {
                disponibles.add(0, usuActual);
            }
        }
        return disponibles;
    }

    public void crearAdministrativo(String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                                   String sector, String nombreUsuario, String pass, String rol) {
        Usuario usuario = new Usuario();
        usuario.setNombre_usuario(nombreUsuario);
        usuario.setPassword(PasswordUtils.hashPassword(pass));
        usuario.setRol((rol != null && !rol.trim().isEmpty()) ? rol : "Administrativo");

        Administrativo admin = new Administrativo();
        admin.setDni(dni);
        admin.setNombre(nombre);
        admin.setApellido(apellido);
        admin.setDireccion(direccion);
        admin.setTelefono(telefono);
        admin.setFecha_nacimiento(fechaNac);
        admin.setSector(sector);

        persistenceC.crearAdministrativo(admin, usuario);
    }

    public void crearAdministrativoConUsuarioExistente(String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                                                      String sector, int idUsuario) {
        Usuario usuarioExistente = persistenceC.getUsuario(idUsuario);
        if (usuarioExistente == null) {
            throw new IllegalArgumentException("El usuario seleccionado no existe.");
        }

        Administrativo admin = new Administrativo();
        admin.setDni(dni);
        admin.setNombre(nombre);
        admin.setApellido(apellido);
        admin.setDireccion(direccion);
        admin.setTelefono(telefono);
        admin.setFecha_nacimiento(fechaNac);
        admin.setSector(sector);

        persistenceC.crearAdministrativoConUsuarioExistente(admin, usuarioExistente);
    }

    public void editAdministrativo(int idAdmin, String dni, String nombre, String apellido, String direccion, String telefono, Date fechaNac,
                                  String sector, int idUsuario) {
        Administrativo admin = persistenceC.getAdministrativo(idAdmin);
        if (admin == null) {
            throw new IllegalArgumentException("El administrativo a modificar no existe.");
        }

        admin.setDni(dni);
        admin.setNombre(nombre);
        admin.setApellido(apellido);
        admin.setDireccion(direccion);
        admin.setTelefono(telefono);
        admin.setFecha_nacimiento(fechaNac);
        admin.setSector(sector);

        if (idUsuario > 0) {
            Usuario u = persistenceC.getUsuario(idUsuario);
            admin.setUsuarioAdministrativo(u);
        } else if (idUsuario == 0) {
            admin.setUsuarioAdministrativo(null);
        }

        persistenceC.editAdministrativo(admin);
    }

    // --- Métodos de Gestión de Citas ---
    public List<Cita> getCitas() {
        return persistenceC.getCitas();
    }

    public void eliminarCita(int id) {
        persistenceC.eliminarCita(id);
    }

    public void crearCita(int idMedico, int idPaciente, Date fechaCita, String horaCita, String motivo) throws IllegalArgumentException {
        Medico med = persistenceC.getMedico(idMedico);
        if (med == null) {
            throw new IllegalArgumentException("El médico seleccionado no existe.");
        }

        Paciente pac = persistenceC.getPaciente(idPaciente);
        if (pac == null) {
            throw new IllegalArgumentException("El paciente seleccionado no existe.");
        }

        // Validación de Horario de Trabajo del Médico
        Horario hor = med.getHorarioMedico();
        if (hor == null || hor.getHora_inicio() == null || hor.getHora_fin() == null ||
            hor.getHora_inicio().isEmpty() || hor.getHora_fin().isEmpty()) {
            throw new IllegalArgumentException("El médico Dr./Dra. " + med.getNombre() + " " + med.getApellido() + " no tiene un horario laboral configurado.");
        }

        try {
            LocalTime horaSeleccionada = LocalTime.parse(horaCita);
            LocalTime horaInicio = LocalTime.parse(hor.getHora_inicio());
            LocalTime horaFin = LocalTime.parse(hor.getHora_fin());

            if (horaSeleccionada.isBefore(horaInicio) || horaSeleccionada.isAfter(horaFin)) {
                throw new IllegalArgumentException("La hora seleccionada (" + horaCita + ") está fuera del horario de trabajo del Dr./Dra. " 
                        + med.getNombre() + " " + med.getApellido() + " (" + hor.getHora_inicio() + " a " + hor.getHora_fin() + ").");
            }
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception ex) {
            throw new IllegalArgumentException("Formato de hora no válido: " + horaCita);
        }

        // Validación de no solapamiento
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaStr = sdf.format(fechaCita);
        List<Cita> citasExistentes = persistenceC.getCitas();
        if (citasExistentes != null) {
            for (Cita c : citasExistentes) {
                if (c.getCitaMedico() != null && c.getCitaMedico().getId_persona() == idMedico) {
                    if (c.getFecha_cita() != null && sdf.format(c.getFecha_cita()).equals(fechaStr)) {
                        if (c.getHora_cita() != null && c.getHora_cita().equals(horaCita)) {
                            throw new IllegalArgumentException("El Dr./Dra. " + med.getNombre() + " " + med.getApellido() + " ya tiene una cita asignada el " + fechaStr + " a las " + horaCita + ".");
                        }
                    }
                }
            }
        }

        Cita cita = new Cita();
        cita.setCitaMedico(med);
        cita.setPaciente(pac);
        cita.setFecha_cita(fechaCita);
        cita.setHora_cita(horaCita);
        cita.setMotivo(motivo);

        persistenceC.crearCita(cita);
    }

    // --- Métodos de Informes Médicos e Historial Clínico ---

    public Medico getMedicoPorUsuario(String nombreUsuario) {
        if (nombreUsuario == null) return null;
        List<Medico> medicos = persistenceC.getMedicos();
        if (medicos != null) {
            for (Medico m : medicos) {
                if (m.getUsuarioMedico() != null && nombreUsuario.equalsIgnoreCase(m.getUsuarioMedico().getNombre_usuario())) {
                    return m;
                }
            }
        }
        return null;
    }

    public InformeMedico crearInformeMedico(int idPaciente, int idMedico, String motivo,
                                            String diagnostico, String tratamiento,
                                            String observaciones, Date fecha) throws IllegalArgumentException {
        Paciente pac = persistenceC.getPaciente(idPaciente);
        if (pac == null) {
            throw new IllegalArgumentException("El paciente seleccionado no existe.");
        }

        Medico med = null;
        if (idMedico > 0) {
            med = persistenceC.getMedico(idMedico);
        }

        InformeMedico inf = new InformeMedico();
        inf.setPaciente(pac);
        inf.setMedico(med);
        inf.setFecha_informe(fecha != null ? fecha : new Date());
        inf.setMotivo_consulta(motivo != null ? motivo.trim() : "");
        inf.setDiagnostico(diagnostico != null ? diagnostico.trim() : "");
        inf.setTratamiento(tratamiento != null ? tratamiento.trim() : "");
        inf.setObservaciones(observaciones != null ? observaciones.trim() : "");

        persistenceC.crearInforme(inf);
        return inf;
    }

    public List<InformeMedico> getInformes() {
        return persistenceC.getInformes();
    }

    public InformeMedico getInforme(int id) {
        return persistenceC.getInforme(id);
    }

    public void eliminarInforme(int id) {
        persistenceC.eliminarInforme(id);
    }

    public List<InformeMedico> getInformesPorPaciente(int idPaciente) {
        List<InformeMedico> todos = persistenceC.getInformes();
        List<InformeMedico> resultado = new ArrayList<>();
        if (todos != null) {
            for (InformeMedico inf : todos) {
                if (inf.getPaciente() != null && inf.getPaciente().getId_persona() == idPaciente) {
                    resultado.add(inf);
                }
            }
            resultado.sort((a, b) -> {
                if (a.getFecha_informe() == null || b.getFecha_informe() == null) return 0;
                return b.getFecha_informe().compareTo(a.getFecha_informe());
            });
        }
        return resultado;
    }

    public List<Cita> getCitasPorPaciente(int idPaciente) {
        List<Cita> todas = persistenceC.getCitas();
        List<Cita> resultado = new ArrayList<>();
        if (todas != null) {
            for (Cita c : todas) {
                if (c.getPaciente() != null && c.getPaciente().getId_persona() == idPaciente) {
                    resultado.add(c);
                }
            }
            resultado.sort((a, b) -> {
                if (a.getFecha_cita() == null || b.getFecha_cita() == null) return 0;
                int cmp = b.getFecha_cita().compareTo(a.getFecha_cita());
                if (cmp != 0) return cmp;
                if (a.getHora_cita() == null || b.getHora_cita() == null) return 0;
                return b.getHora_cita().compareTo(a.getHora_cita());
            });
        }
        return resultado;
    }
}
