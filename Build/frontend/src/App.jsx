import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./components/AuthContext";
import Header from "./components/Header";
import Footer from "./components/Footer";
import Inicio from "./pages/Inicio";
import Login from "./pages/Login";
import Registro from "./pages/Registro";
import Diagnostico from "./pages/Diagnostico";
import Resultados from "./pages/Resultados";
import AdminPanel from "./pages/AdminPanel";
import AdminDiagnosticos from "./pages/AdminDiagnosticos";
import Configuracion from "./pages/Configuracion";
import "./styles/main.css";

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="page-wrapper">
          <Header />
          <main className="container main-content">
            <Routes>
              <Route path="/" element={<Inicio />} />
              <Route path="/login" element={<Login />} />
              <Route path="/registro" element={<Registro />} />
              <Route path="/diagnostico" element={<Diagnostico />} />
              <Route path="/configuracion" element={<Configuracion />} />
              <Route
                path="/admin/diagnosticos/:paciente_id"
                element={<AdminDiagnosticos />}
              />
              <Route path="/admin" element={<AdminPanel />} />
              <Route path="/resultados" element={<Resultados />} />
            </Routes>
          </main>
          <Footer />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
