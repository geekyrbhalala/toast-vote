import React from "react";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";

const Home = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <header className="bg-green-600 text-white text-center py-5">
        <h1 className="text-2xl font-bold">Welcome to Toast-Vote</h1>
        <p>Your Toastmasters club's easy voting and evaluation system</p>
      </header>
      
      <main className="flex-1 flex flex-col items-center justify-center px-4">
        <h2 className="text-xl font-semibold mb-6">Get Started</h2>
        <div className="space-x-4">
          <Link to="/vote" className="bg-green-600 text-white px-6 py-3 rounded-lg text-lg hover:bg-green-700">Start Voting</Link>
          <Link to="/results" className="bg-green-600 text-white px-6 py-3 rounded-lg text-lg hover:bg-green-700">View Results</Link>
        </div>
      </main>
      
      <footer className="bg-gray-800 text-white text-center py-3 mt-auto">
        <p>&copy; 2025 Toast-Vote App | All Rights Reserved</p>
      </footer>
    </div>
  );
};

const Vote = () => <div className="text-center mt-10 text-xl">Voting Page (Under Construction)</div>;
const Results = () => <div className="text-center mt-10 text-xl">Results Page (Under Construction)</div>;

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/vote" element={<Vote />} />
        <Route path="/results" element={<Results />} />
      </Routes>
    </Router>
  );
};

export default App;
