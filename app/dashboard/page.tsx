"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";;

const adminMenus = [
  ["▦", "Dashboard"],
  ["♟", "Data Petugas"],
  ["▣", "Jadwal Piket"],
  ["✓", "Monitoring Checklist"],
  ["▤", "Laporan Harian Piket"],
  ["▧", "Dokumentasi Foto/Video"],
  ["📍", "Monitoring Live Location"],
  ["◉", "Pengaduan Pelanggan"],
  ["▦", "Riwayat Verifikasi QR"],
  ["♙", "Profil Admin"],
];
const kepalaMenus = [
  ["▦", "Dashboard"],
  ["▣", "Penugasan Harian"],
  ["◉", "Monitoring Pengaduan"],
  ["♟", "Laporan Pelanggan Baru"],
  ["⚠", "Laporan Gangguan"],
  ["▥", "Laporan Kinerja Petugas"],
  ["✓", "Pemeriksaan Laporan"],
  ["▥", "Monitoring Pelaksanaan Piket"],
  ["▧", "Dokumentasi Foto/Video"],
  ["📍", "Monitoring Live Location"],
  ["♙", "Profil Kepala SITE"],
];

const adminRoutes: Record<string, string> = {
  Dashboard: "/dashboard",
  "Data Petugas": "/dashboard/petugas",
  "Jadwal Piket": "/dashboard/guru-piket",
  "Monitoring Checklist": "/dashboard/checklist",
  "Laporan Harian Piket": "/dashboard/laporan-piket",
  "Dokumentasi Foto/Video": "/dashboard/dokumentasi",
  "Monitoring Live Location": "/dashboard/monitoring-lokasi",
  "Pengaduan Pelanggan": "/dashboard/pengaduan",
  "Riwayat Verifikasi QR": "/dashboard/riwayat-qr",
  "Profil Admin": "/dashboard/profil",
};

const kepalaRoutes: Record<string, string> = {
  Dashboard: "/dashboard",
  "Penugasan Harian": "/dashboard/penugasan",
  "Monitoring Pengaduan": "/dashboard/monitoring-pengaduan",
  "Laporan Pelanggan Baru": "/dashboard/laporan-pelanggan-baru",
  "Laporan Gangguan": "/dashboard/laporan-gangguan",
  "Laporan Kinerja Petugas": "/dashboard/laporan-kinerja",
  "Pemeriksaan Laporan": "/dashboard/pemeriksaan-laporan",
  "Monitoring Pelaksanaan Piket": "/dashboard/monitoring-piket",
  "Dokumentasi Foto/Video": "/dashboard/dokumentasi-kepala",
  "Monitoring Live Location": "/dashboard/lokasi-kepala",
  "Profil Kepala SITE": "/dashboard/profil-kepala",
};

const stats = [
  ["♟", "24", "Total Petugas"],
  ["▦", "5", "Jadwal Piket Aktif"],
  ["▰", "12", "Pengaduan Baru"],
  ["▤", "8", "Laporan Masuk"],
];

const activities = [
  ["▣", "Jadwal piket diperbarui oleh Admin", "1 jam yang lalu"],
  ["▰", "Pengaduan baru dari Pelanggan", "2 jam yang lalu"],
  ["✓", "Laporan aktivitas petugas telah diisi", "3 jam yang lalu"],
  ["♟", "Data petugas baru ditambahkan", "1 hari yang lalu"],
];

export default function Dashboard() {
  const router = useRouter();
  const [menuOpen, setMenuOpen] = useState(false);
  const [role, setRole] = useState("admin");
const [namaPengguna, setNamaPengguna] = useState("Admin");

useEffect(() => {
  const dataUser = localStorage.getItem("sijalink_user");

  if (dataUser) {
    try {
      const user = JSON.parse(dataUser);

      setRole(user.role);
      setNamaPengguna(user.name || "Pengguna SIJALink");
    } catch {
      console.error("Data akun tidak valid");
    }
  }
}, []);

  return (
    <div className="min-h-screen bg-[#f2f7ff] text-[#102d60]">

      {/* OVERLAY HP */}
      {menuOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => setMenuOpen(false)}
        />
      )}

      {/* SIDEBAR */}
      <aside
        className={`fixed inset-y-0 left-0 z-50 w-[270px] overflow-y-auto bg-[#082d68] p-5 text-white transition-transform duration-300 lg:translate-x-0 ${
          menuOpen ? "translate-x-0" : "-translate-x-full"
        }`}
      >
       <div className="mb-10 flex items-center justify-between">
  <div className="flex w-full flex-col items-center">
  <div className="mb-2 text-5xl">🎧</div>
  <h1 className="text-3xl font-bold italic">
    SIJA<span className="text-sky-400">Link</span>
  </h1>
</div>

  <button
    onClick={() => setMenuOpen(false)}
    className="text-2xl lg:hidden"
  >
    ✕
  </button>
</div>

{role === "admin" ? (
  <>
    <p className="mb-3 text-sm text-blue-200">
      Menu Admin
    </p>

    <nav className="space-y-2">
      {adminMenus.map(([icon, label], index) => (
        <Link
          key={label}
          href={adminRoutes[label] || "/dashboard"}
          onClick={() => setMenuOpen(false)}
          className={`flex items-center gap-4 rounded-xl px-4 py-3 text-sm transition ${
            index === 0
              ? "bg-blue-600 font-semibold"
              : "hover:bg-blue-800"
          }`}
        >
          <span className="text-xl">{icon}</span>
          {label}
        </Link>
      ))}
    </nav>
  </>
) : role === "kepala" ? (
  <>
    <p className="mb-3 text-sm text-blue-200">
      Menu Kepala SITE
    </p>

    <nav className="space-y-2">
      {kepalaMenus.map(([icon, label], index) => (
        <Link
          key={label}
          href={kepalaRoutes[label] || "/dashboard"}
          onClick={() => setMenuOpen(false)}
          className={`flex items-center gap-4 rounded-xl px-4 py-3 text-sm transition ${
            index === 0
              ? "bg-blue-600 font-semibold"
              : "hover:bg-blue-800"
          }`}
        >
          <span className="text-xl">{icon}</span>
          {label}
        </Link>
      ))}
    </nav>
  </>
) : (
  <p className="rounded-xl bg-blue-900 p-3 text-sm">
    Akun ini tidak memiliki akses Dashboard Admin atau Kepala SITE.
  </p>
)}

      <button
onClick={() => {
  localStorage.removeItem("sijalink_user");
  router.push("/login");
}}
  className="mt-8 w-full border-t border-blue-700 pt-6 text-left text-sm hover:text-blue-200"
>
  ⇥ Logout
</button>
      </aside>

      {/* KONTEN UTAMA */}
      <main className="min-h-screen p-4 sm:p-6 lg:ml-[270px] lg:p-8">

        {/* HEADER */}
        <header className="mb-6 flex flex-wrap items-center justify-between gap-4 rounded-2xl border border-blue-100 bg-white p-4 shadow-sm sm:p-6">

          <div className="flex items-center gap-3">
            <button
              onClick={() => setMenuOpen(true)}
              className="rounded-lg bg-blue-50 px-3 py-2 text-2xl text-blue-900 lg:hidden"
              aria-label="Buka menu"
            >
              ☰
            </button>

            <div>
              <p className="text-sm text-slate-500">
                Selamat Datang,
              </p>
              <h2 className="text-2xl font-bold text-[#0b3069] sm:text-3xl">
                SIJALink 👋
              </h2>
              <p className="mt-1 hidden text-sm text-slate-500 sm:block">
                Kelola data dan pantau aktivitas sistem dengan mudah.
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <button className="text-xl text-blue-800" aria-label="Notifikasi">
              ♧
            </button>

            <div className="flex items-center gap-2 rounded-xl bg-blue-50 p-2 sm:gap-3 sm:p-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-[#103c82] font-bold text-white">
                AD
              </div>

              <div>
                <p className="text-sm font-semibold">{namaPengguna}</p>
               <p className="hidden text-xs text-slate-500 sm:block">
                  {role === "kepala" ? "Kepala SITE" : "Administrator"}
              </p>
              </div>
              <span>⌄</span>
            </div>
          </div>
        </header>

        {/* KARTU RINGKASAN */}
        <section className="mb-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {stats.map(([icon, number, label]) => (
            <div
              key={label}
              className="flex items-center gap-4 rounded-2xl border border-blue-100 bg-white p-5 shadow-sm"
            >
              <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-full bg-blue-100 text-2xl text-blue-800 sm:h-16 sm:w-16">
                {icon}
              </div>

              <div>
                <h3 className="text-3xl font-bold">{number}</h3>
                <p className="text-sm text-slate-500">{label}</p>
              </div>
            </div>
          ))}
        </section>

        {/* AKTIVITAS DAN MONITORING */}
        <section className="grid grid-cols-1 gap-5 xl:grid-cols-[1.3fr_1fr]">

          {/* AKTIVITAS TERBARU */}
          <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm sm:p-6">
            <div className="mb-5 flex items-center justify-between border-b border-slate-100 pb-4">
              <h3 className="text-lg font-bold sm:text-xl">
                Aktivitas Terbaru
              </h3>
              <a href="#" className="text-xs font-semibold text-blue-600 sm:text-sm">
                Lihat Semua →
              </a>
            </div>

            <div className="space-y-5">
              {activities.map(([icon, title, time]) => (
                <div
                  key={title}
                  className="flex items-center gap-3 border-b border-slate-100 pb-4 last:border-0"
                >
                  <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-blue-100 text-xl text-blue-800">
                    {icon}
                  </div>

                  <div>
                    <p className="text-sm font-semibold">{title}</p>
                    <p className="mt-1 text-xs text-slate-500">{time}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* BAGIAN KANAN */}
          <div className="space-y-5">

            {/* MONITORING LOKASI */}
            <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
              <div className="mb-4 flex items-center justify-between">
                <h3 className="text-lg font-bold">
                  Monitoring Lokasi
                </h3>
                <a href="#" className="text-xs font-semibold text-blue-600">
                  Lihat Detail →
                </a>
              </div>

              <div className="relative flex h-48 items-center justify-center overflow-hidden rounded-xl bg-gradient-to-br from-blue-100 via-slate-100 to-green-100">
                <div className="text-center">
                  <div className="text-5xl">📍</div>
                  <p className="mt-3 rounded-lg bg-white px-4 py-2 text-xs font-semibold shadow">
                    🟢 Petugas Aktif
                  </p>
                </div>
              </div>
            </div>

            {/* RINGKASAN LAPORAN */}
            <div className="rounded-2xl border border-blue-100 bg-white p-5 shadow-sm">
              <div className="mb-4 flex items-center justify-between">
                <h3 className="text-lg font-bold">
                  Ringkasan Laporan
                </h3>
                <a href="#" className="text-xs font-semibold text-blue-600">
                  Lihat Semua →
                </a>
              </div>

              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <p className="text-sm font-bold">
                    Laporan Kinerja Petugas
                  </p>
                  <p className="mt-1 text-xs text-slate-500">
                    Ringkasan laporan petugas
                  </p>
                </div>

                <button className="rounded-xl bg-[#0b3476] px-4 py-2 text-sm font-semibold text-white hover:bg-blue-800">
                  Unduh Laporan ↓
                </button>
              </div>
            </div>

          </div>
        </section>

        <footer className="mt-8 border-t border-blue-100 py-5 text-center text-xs text-slate-500">
          © 2026 SIJALink. All Rights Reserved.
        </footer>

      </main>
    </div>
  );
}
