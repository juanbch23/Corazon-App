import { useEffect, useState, useRef } from "react";
import api from "../api/axios";
import Chart from "chart.js/auto";
import "../styles/Resultados.css";

function Resultados() {
  const [diagnostico, setDiagnostico] = useState(null);
  const [loading, setLoading] = useState(true);
  const canvasRef = useRef(null);
  const [alerta, setAlerta] = useState("");

  useEffect(() => {
    const fetchResultados = async () => {
      try {
        const res = await api.get("/resultados");
        setDiagnostico(res.data.diagnostico);
      } catch (err) {
        console.error("Error obteniendo resultados:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchResultados();
  }, []);

  useEffect(() => {
    if (diagnostico && canvasRef.current) {
      const ctx = canvasRef.current.getContext("2d");
      const confianza = (diagnostico.confianza * 100).toFixed(1);
      let color = "#28a745";
      let mensaje = "¡Estás en buen estado!";
      if (diagnostico.riesgo === 1) {
        color = "#ffc107";
        mensaje = "Precaución: cuida tus hábitos";
      }
      if (diagnostico.riesgo === 2) {
        color = "#dc3545";
        mensaje = "¡Alerta! Riesgo alto, consulta urgente";
      }
      setAlerta(mensaje);
      // Destruir gráfico anterior si existe
      if (window.riskChartInstance) {
        window.riskChartInstance.destroy();
      }
      window.riskChartInstance = new Chart(ctx, {
        type: "doughnut",
        data: {
          labels: ["Confianza", "Restante"],
          datasets: [
            {
              data: [confianza, 100 - confianza],
              backgroundColor: [color, "#e9ecef"],
              borderWidth: 0,
            },
          ],
        },
        options: {
          cutout: "70%",
          plugins: {
            legend: { display: false },
          },
          animation: {
            animateRotate: true,
            animateScale: false,
            duration: 1000,
            easing: "easeOutCubic",
          },
        },
      });
    }
  }, [diagnostico]);

  const formatearFecha = (fechaStr) => {
    const fecha = new Date(fechaStr);
    return fecha.toLocaleString();
  };

  const obtenerTextoRiesgo = (nivel) => {
    if (nivel === 0) return "Bajo";
    if (nivel === 1) return "Medio";
    return "Alto";
  };

  if (loading) return <p>Cargando resultados...</p>;

  return (
    <div className="results-container">
      <h2>Resultados de tu Diagnóstico</h2>

      {diagnostico ? (
        <div className="result-card">
          <div
            className="result-graph"
            style={{ position: "relative", width: "200px", height: "200px" }}
          >
            <canvas
              id="riskChart"
              ref={canvasRef}
              width="200"
              height="200"
            ></canvas>
            <div className="confidence-label">
              <span style={{ fontSize: "28px", fontWeight: "bold" }}>
                {(diagnostico.confianza * 100).toFixed(1)}%
              </span>
              <br />
              <small style={{ fontSize: "16px" }}>Confianza</small>
            </div>
          </div>
          <div className="result-details" style={{ marginTop: 24 }}>
            <h3 style={{ marginBottom: 10 }}>
              Nivel de Riesgo:{" "}
              <span
                className={`risk-${diagnostico.riesgo}`}
                style={{ fontWeight: "bold", fontSize: 20 }}
              >
                {obtenerTextoRiesgo(diagnostico.riesgo)}
              </span>
            </h3>
            <p style={{ marginBottom: 18 }}>
              Fecha del diagnóstico:{" "}
              <strong>{formatearFecha(diagnostico.fecha)}</strong>
            </p>
            <div className="recommendations" style={{ marginTop: 18 }}>
              <h4 style={{ marginBottom: 8 }}>Recomendaciones:</h4>
              {diagnostico.riesgo === 0 && (
                <p>
                  Continúa con tus hábitos saludables. Realiza chequeos anuales.
                </p>
              )}
              {diagnostico.riesgo === 1 && (
                <p>
                  Mejora tu dieta y aumenta la actividad física. Consulta a un
                  especialista.
                </p>
              )}
              {diagnostico.riesgo === 2 && (
                <p>
                  Consulta urgentemente con un cardiólogo. Necesitas atención
                  médica inmediata.
                </p>
              )}
            </div>
          </div>
        </div>
      ) : (
        <div className="no-results">
          <p>Aún no has realizado ningún diagnóstico.</p>
        </div>
      )}
    </div>
  );
}

export default Resultados;
