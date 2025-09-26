import "../styles/Inicio.css";
import corazonImg from "../assets/image1.jpg";
import { Link } from "react-router-dom";

function Inicio() {
  return (
    <div className="inicio-container">
      <section className="banner">
        <img src={corazonImg} alt="Salud del Corazón" className="banner-img" />
        <div className="banner-texto">
          <h1>Bienvenido a Salud del Corazón</h1>
          <p>
            Tu aliado en la prevención y diagnóstico de enfermedades cardíacas.
          </p>
        </div>
      </section>

      <section className="seccion seccion-intro">
        <h2>¿Qué es la salud cardiovascular?</h2>
        <p>
          La salud cardiovascular se refiere al buen funcionamiento del corazón
          y los vasos sanguíneos. Mantenerla en buen estado es fundamental para
          prevenir infartos, hipertensión y otras enfermedades crónicas. Conocer
          tu estado de salud te permite actuar a tiempo.
        </p>
      </section>

      <section className="seccion seccion-enfermedades">
        <h2>Enfermedades cardíacas más comunes</h2>
        <div className="tarjetas">
          <div className="tarjeta">
            <h3>Infarto de miocardio</h3>
            <p>
              Ocurre cuando el flujo sanguíneo se bloquea en una parte del
              corazón. Es una emergencia médica.
            </p>
          </div>
          <div className="tarjeta">
            <h3>Insuficiencia cardíaca</h3>
            <p>
              El corazón no puede bombear suficiente sangre para satisfacer las
              necesidades del cuerpo.
            </p>
          </div>
          <div className="tarjeta">
            <h3>Arritmias</h3>
            <p>
              Latidos irregulares del corazón que pueden causar mareos, fatiga o
              desmayos.
            </p>
          </div>
        </div>
      </section>

      <section className="seccion seccion-prevencion">
        <h2>Consejos para prevenir enfermedades del corazón</h2>
        <ul>
          <li>✔ Alimentación saludable</li>
          <li>✔ Actividad física regular</li>
          <li>✔ Control del estrés</li>
          <li>✔ No fumar</li>
          <li>✔ Controles médicos frecuentes</li>
        </ul>
      </section>

      <section className="seccion seccion-diagnostico">
        <h2>¿Quieres conocer tu riesgo cardíaco?</h2>
        <p>
          Nuestro sistema predictivo basado en inteligencia artificial puede
          ayudarte a identificar riesgos cardíacos a tiempo.
        </p>
        <Link to="/diagnostico" className="boton-diagnostico">
          Realizar Diagnóstico
        </Link>
      </section>

      <section className="seccion seccion-noticias">
        <h2>Actualidad en salud cardíaca</h2>
        <div className="tarjetas">
          <div className="tarjeta">
            <h3>Estudio reciente sobre colesterol</h3>
            <p>
              Investigaciones revelan cómo el colesterol LDL sigue siendo un
              factor de riesgo principal en adultos jóvenes.
            </p>
          </div>
          <div className="tarjeta">
            <h3>IA en la medicina preventiva</h3>
            <p>
              La inteligencia artificial permite realizar evaluaciones de riesgo
              más precisas en segundos.
            </p>
          </div>
          <div className="tarjeta">
            <h3>Ejercicio para el corazón</h3>
            <p>
              30 minutos de caminata diaria puede reducir el riesgo de
              enfermedades cardiovasculares en un 40%.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}

export default Inicio;
