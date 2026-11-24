package persistence;

import Logica.Usuario;
import persistence.AdministrativoJpaController;
import persistence.PersonaJpaController;
import persistence.ResponsableJpaController;
import persistence.UsuarioJpaController;

public class PersistenceController {

    PersonaJpaController personaJPAC = new PersonaJpaController();
    HorarioJpaController horaJPAC = new HorarioJpaController();
    MedicoJpaController medicoJPAC = new MedicoJpaController();
    PacienteJpaController pacienteJPAC = new PacienteJpaController();
    CitaJpaController citaJPAC = new CitaJpaController();
    ResponsableJpaController responsableJPAC = new ResponsableJpaController();
    AdministrativoJpaController administrativoJPAC = new AdministrativoJpaController();
    UsuarioJpaController usuarioJPAC = new UsuarioJpaController();

    public PersistenceController() {

    }

    public PersistenceController(MedicoJpaController medicoJPAC, HorarioJpaController horaJPAC, PersonaJpaController personaJPAC, UsuarioJpaController usuarioJPAC, AdministrativoJpaController administrativoJPAC, ResponsableJpaController responsableJPAC, CitaJpaController citaJPAC, PacienteJpaController pacienteJPAC) {
        this.medicoJPAC = medicoJPAC;
        this.horaJPAC = horaJPAC;
        this.personaJPAC = personaJPAC;
        this.usuarioJPAC = usuarioJPAC;
        this.administrativoJPAC = administrativoJPAC;
        this.responsableJPAC = responsableJPAC;
        this.citaJPAC = citaJPAC;
        this.pacienteJPAC = pacienteJPAC;
    }

    public void crearUsuario(Usuario usuario) {

        usuarioJPAC.create(usuario);
    }
}
