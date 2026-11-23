package Persistence;

import Logica.Usuario;

public class PersistenceController {

    PersonaJpaController personaJPAC = new PersonaJpaController();
    HorarioJpaController horaJPAC = new HorarioJpaController();
    MedicoJpaController medicoJPAC = new MedicoJpaController();
    PacienteJpaController pacienteJPAC = new PacienteJpaController();
    CitaJpaController citaJPAC = new CitaJpaController();
    ResponsableJpaController responsableJPAC = new ResponsableJpaController();
    AdministrativoJpaController administrativoJPAC = new AdministrativoJpaController();
    UsuarioJpaController usuarioJPAC = new UsuarioJpaController();

    public void crearUsuario(Usuario usuario) {

        usuarioJPAC.create(usuario);
    }
}
