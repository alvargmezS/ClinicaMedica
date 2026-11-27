package persistence;

import Logica.Administrativo;
import Logica.Cita;
import Logica.Horario;
import Logica.InformeMedico;
import Logica.Medico;
import Logica.Paciente;
import Logica.Responsable;
import Logica.Usuario;
import jakarta.persistence.EntityManagerFactory;
import perisistenceexception.NonexistentEntityException;

import java.util.Date;
import java.util.List;

public class PersistenceController {

    PersonaJpaController personaJPAC;
    HorarioJpaController horaJPAC;
    MedicoJpaController medicoJPAC;
    PacienteJpaController pacienteJPAC;
    CitaJpaController citaJPAC;
    ResponsableJpaController responsableJPAC;
    AdministrativoJpaController administrativoJPAC;
    UsuarioJpaController usuarioJPAC;
    InformeMedicoJpaController informeJPAC;

    public PersistenceController() {
        EntityManagerFactory emf = EntityManagerUtil.getEntityManagerFactory();
        this.personaJPAC = new PersonaJpaController(emf);
        this.horaJPAC = new HorarioJpaController(emf);
        this.medicoJPAC = new MedicoJpaController(emf);
        this.pacienteJPAC = new PacienteJpaController(emf);
        this.citaJPAC = new CitaJpaController(emf);
        this.responsableJPAC = new ResponsableJpaController(emf);
        this.administrativoJPAC = new AdministrativoJpaController(emf);
        this.usuarioJPAC = new UsuarioJpaController(emf);
        this.informeJPAC = new InformeMedicoJpaController(emf);
    }

    public PersistenceController(MedicoJpaController medicoJPAC, HorarioJpaController horaJPAC, PersonaJpaController personaJPAC, UsuarioJpaController usuarioJPAC, AdministrativoJpaController administrativoJPAC, ResponsableJpaController responsableJPAC, CitaJpaController citaJPAC, PacienteJpaController pacienteJPAC, InformeMedicoJpaController informeJPAC) {
        this.medicoJPAC = medicoJPAC;
        this.horaJPAC = horaJPAC;
        this.personaJPAC = personaJPAC;
        this.usuarioJPAC = usuarioJPAC;
        this.administrativoJPAC = administrativoJPAC;
        this.responsableJPAC = responsableJPAC;
        this.citaJPAC = citaJPAC;
        this.pacienteJPAC = pacienteJPAC;
        this.informeJPAC = informeJPAC;
    }

    public void crearUsuario(Usuario usuario) {

        usuarioJPAC.create(usuario);
    }

    public List<Usuario> getUsuarios() {
        return usuarioJPAC.findUsuarioEntities();
    }

    public List<Medico> getMedicos() {

        return medicoJPAC.findMedicoEntities();
    }

    public Medico getMedico(int id) {
        return medicoJPAC.findMedico(id);
    }

    public void deleteUsuario(int id) {
        try {
            // Desvincular de médicos si estuviera asignado para mantener integridad referencial
            List<Medico> medicos = medicoJPAC.findMedicoEntities();
            if (medicos != null) {
                for (Medico m : medicos) {
                    if (m.getUsuarioMedico() != null && m.getUsuarioMedico().getId_usuario() == id) {
                        m.setUsuarioMedico(null);
                        try {
                            medicoJPAC.edit(m);
                        } catch (Exception ignored) {}
                    }
                }
            }

            // Desvincular de administrativos si estuviera asignado
            List<Administrativo> admins = administrativoJPAC.findAdministrativoEntities();
            if (admins != null) {
                for (Administrativo a : admins) {
                    if (a.getUsuarioAdministrativo() != null && a.getUsuarioAdministrativo().getId_usuario() == id) {
                        a.setUsuarioAdministrativo(null);
                        try {
                            administrativoJPAC.edit(a);
                        } catch (Exception ignored) {}
                    }
                }
            }

            usuarioJPAC.destroy(id);
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }

    public Usuario getUsuario(int id) {
        return usuarioJPAC.findUsuario(id);
    }

    public void editUsuario(Usuario usu) {
        try {
            usuarioJPAC.edit(usu);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public void crearMedico(Medico med, Horario horario, Usuario usuario) {

        // 1. Persistimos primero el horario y el usuario
        horaJPAC.create(horario);
        usuarioJPAC.create(usuario);

        // 2. Asociamos el horario y el usuario recién guardados al médico
        med.setHorarioMedico(horario);
        med.setUsuarioMedico(usuario);

        // 3. Persistimos el médico
        medicoJPAC.create(med);
    }

    public void crearMedicoConUsuarioExistente(Medico med, Horario horario, Usuario usuario) {

        // 1. Persistimos primero el horario (el usuario ya existe)
        horaJPAC.create(horario);

        // 2. Asociamos el horario y el usuario existente al médico
        med.setHorarioMedico(horario);
        med.setUsuarioMedico(usuario);

        // 3. Persistimos el médico
        medicoJPAC.create(med);
    }

    public void deleteMedico(int id) {
        try {
            // Eliminar citas previas del médico para respetar integridad referencial
            List<Cita> todasCitas = citaJPAC.findCitaEntities();
            if (todasCitas != null) {
                for (Cita c : todasCitas) {
                    if (c.getCitaMedico() != null && c.getCitaMedico().getId_persona() == id) {
                        citaJPAC.destroy(c.getId_cita());
                    }
                }
            }

            // Desvincular informes médicos asociados a este doctor
            List<InformeMedico> todosInformes = informeJPAC.findInformeMedicoEntities();
            if (todosInformes != null) {
                for (InformeMedico inf : todosInformes) {
                    if (inf.getMedico() != null && inf.getMedico().getId_persona() == id) {
                        inf.setMedico(null);
                        try {
                            informeJPAC.edit(inf);
                        } catch (Exception ignored) {}
                    }
                }
            }

            Medico med = medicoJPAC.findMedico(id);
            Horario hor = (med != null) ? med.getHorarioMedico() : null;

            medicoJPAC.destroy(id);

            // Eliminar horario huérfano si existía
            if (hor != null) {
                try {
                    horaJPAC.destroy(hor.getId_horario());
                } catch (Exception ignored) {}
            }
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }

    public void editMedico(Medico med, Horario hor) {
        try {
            if (hor != null) {
                if (hor.getId_horario() > 0) {
                    horaJPAC.edit(hor);
                } else {
                    horaJPAC.create(hor);
                }
                med.setHorarioMedico(hor);
            }
            medicoJPAC.edit(med);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // --- Métodos para Citas ---
    public List<Cita> getCitas() {
        return citaJPAC.findCitaEntities();
    }

    public Cita getCita(int id) {
        return citaJPAC.findCita(id);
    }

    public void crearCita(Cita cita) {
        citaJPAC.create(cita);
    }

    public void eliminarCita(int id) {
        try {
            citaJPAC.destroy(id);
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }

    // --- Métodos para Pacientes ---
    public List<Paciente> getPacientes() {
        return pacienteJPAC.findPacienteEntities();
    }

    public Paciente getPaciente(int id) {
        return pacienteJPAC.findPaciente(id);
    }

    public void crearPaciente(Paciente paciente) {
        if (paciente.getResponsable() != null) {
            if (paciente.getResponsable().getId_persona() == 0) {
                responsableJPAC.create(paciente.getResponsable());
            }
        }
        pacienteJPAC.create(paciente);
    }

    public List<Responsable> getResponsables() {
        return responsableJPAC.findResponsableEntities();
    }

    public Responsable getResponsable(int id) {
        return responsableJPAC.findResponsable(id);
    }

    public void crearResponsable(Responsable resp) {
        responsableJPAC.create(resp);
    }

    public void editResponsable(Responsable resp) {
        try {
            responsableJPAC.edit(resp);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void eliminarPaciente(int id) {
        try {
            // Eliminar citas previas del paciente para respetar integridad referencial
            List<Cita> todasCitas = citaJPAC.findCitaEntities();
            if (todasCitas != null) {
                for (Cita c : todasCitas) {
                    if (c.getPaciente() != null && c.getPaciente().getId_persona() == id) {
                        citaJPAC.destroy(c.getId_cita());
                    }
                }
            }

            // Eliminar informes médicos del paciente
            List<InformeMedico> todosInformes = informeJPAC.findInformeMedicoEntities();
            if (todosInformes != null) {
                for (InformeMedico inf : todosInformes) {
                    if (inf.getPaciente() != null && inf.getPaciente().getId_persona() == id) {
                        informeJPAC.destroy(inf.getId_informe());
                    }
                }
            }

            pacienteJPAC.destroy(id);
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }

    public void editPaciente(Paciente paciente) {
        try {
            pacienteJPAC.edit(paciente);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // --- Métodos para Administrativos ---
    public List<Administrativo> getAdministrativos() {
        return administrativoJPAC.findAdministrativoEntities();
    }

    public Administrativo getAdministrativo(int id) {
        return administrativoJPAC.findAdministrativo(id);
    }

    public void crearAdministrativo(Administrativo admin, Usuario usuario) {
        usuarioJPAC.create(usuario);
        admin.setUsuarioAdministrativo(usuario);
        administrativoJPAC.create(admin);
    }

    public void crearAdministrativoConUsuarioExistente(Administrativo admin, Usuario usuario) {
        admin.setUsuarioAdministrativo(usuario);
        administrativoJPAC.create(admin);
    }

    public void editAdministrativo(Administrativo admin) {
        try {
            administrativoJPAC.edit(admin);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void deleteAdministrativo(int id) {
        try {
            administrativoJPAC.destroy(id);
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }

    // --- Métodos para Informes Médicos ---
    public void crearInforme(InformeMedico informe) {
        informeJPAC.create(informe);
    }

    public List<InformeMedico> getInformes() {
        return informeJPAC.findInformeMedicoEntities();
    }

    public InformeMedico getInforme(int id) {
        return informeJPAC.findInformeMedico(id);
    }

    public void editInforme(InformeMedico informe) {
        try {
            informeJPAC.edit(informe);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void eliminarInforme(int id) {
        try {
            informeJPAC.destroy(id);
        } catch (NonexistentEntityException e) {
            throw new RuntimeException(e);
        }
    }
}
