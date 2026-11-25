package persistence;

import Logica.Medico;
import Logica.Usuario;
import perisistenceexception.NonexistentEntityException;

import java.util.List;

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

    public List<Usuario> getUsuarios() {
        return usuarioJPAC.findUsuarioEntities();
    }


    public List<Medico> getMedicos() {

        return medicoJPAC.findMedicoEntities();
    }

    public void deleteUsuario(int id) {

        try {
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
}
