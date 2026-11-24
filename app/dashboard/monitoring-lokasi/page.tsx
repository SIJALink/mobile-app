
"use client";

import { useState } from "react";

type Teknisi = {
  id: number;
  nama: string;
  kode: string;
  wilayah: string;
  status: "Aktif" | "Tidak Aktif";
  durasi: string;
  terakhir: string;
  baterai: number;
};

const dataTeknisi: Teknisi[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    kode: "TKN-001",
    wilayah: "Area Sekolah Utama",
    status: "Aktif",
    durasi: "8 Jam",
    terakhir: "Baru saja",
    baterai: 85,
  },
  {
    id: 2,
    nama: "Budi Santoso",
    kode: "TKN-002",
    wilayah: "Area Gedung Timur",
    status: "Aktif",
    durasi: "4 Jam",
    terakhir: "2 menit lalu",
    baterai: 70,
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    kode: "TKN-003",
    wilayah: "Area Gedung Barat",
    status: "Tidak Aktif",
    durasi: "-",
    terakhir: "1 jam lalu",
    baterai: 45,
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    kode: "TKN-004",
    wilayah: "Area Lapangan",
    status: "Aktif",
    durasi: "8 Jam",
    terakhir: "5 menit lalu",
    baterai: 92,
  },
];

export default function MonitoringLokasiPage() {
  const [teknisi] = useState(dataTeknisi);
  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [dipilih, setDipilih] = useState<Teknisi | null>(null);

  const hasilFilter = teknisi.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.kode.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  const aktif = teknisi.filter(
    (item) => item.status === "Aktif"
  ).length;

  const tidakAktif = teknisi.filter(
    (item) => item.status === "Tidak Aktif"
  ).length;

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Monitoring Lokasi
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Monitoring Live Location Teknisi
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Pantau status berbagi lokasi teknisi yang telah memberikan izin.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <p className="text-sm text-slate-500">
                Total Teknisi
              </p>
              <span className="rounded-xl bg-blue-50 p-3 text-xl">
                👷
              </span>
            </div>

            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {teknisi.length}
            </h2>

            <p className="mt-2 text-xs text-slate-400">
              Teknisi terdaftar
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <p className="text-sm text-slate-500">
                Lokasi Aktif
              </p>
              <span className="rounded-xl bg-green-50 p-3 text-xl">
                📍
              </span>
            </div>

            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {aktif}
            </h2>

            <p className="mt-2 text-xs text-slate-400">
              Sedang berbagi lokasi
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <p className="text-sm text-slate-500">
                Lokasi Tidak Aktif
              </p>
              <span className="rounded-xl bg-orange-50 p-3 text-xl">
                ⏱
              </span>
            </div>

            <h2 className="mt-3 text-3xl font-bold text-orange-500">
              {tidakAktif}
            </h2>

            <p className="mt-2 text-xs text-slate-400">
              Tidak sedang berbagi lokasi
            </p>
          </div>

        </div>

        {/* PETA SIMULASI */}
        <section className="overflow-hidden rounded-2xl bg-white shadow-sm">

          <div className="flex flex-col justify-between gap-2 border-b border-slate-100 p-5 sm:flex-row sm:items-center">
            <div>
              <h2 className="font-bold text-slate-800">
                Peta Monitoring
              </h2>
              <p className="mt-1 text-xs text-slate-400">
                Ilustrasi area pemantauan teknisi
              </p>
            </div>

            <span className="flex items-center gap-2 text-xs font-semibold text-green-600">
              <span className="h-2 w-2 rounded-full bg-green-500" />
              Tampilan simulasi
            </span>
          </div>

          <div className="relative flex min-h-[300px] items-center justify-center overflow-hidden bg-slate-200 p-6">

            <div className="absolute inset-0 opacity-40"
              style={{
                backgroundImage:
                  "linear-gradient(90deg, white 1px, transparent 1px), linear-gradient(white 1px, transparent 1px)",
                backgroundSize: "45px 45px",
              }}
            />

            <div className="relative z-10 grid w-full max-w-lg grid-cols-2 gap-4">

              <div className="rounded-2xl border border-white bg-white/90 p-5 text-center shadow-sm">
                <span className="text-3xl">🏫</span>
                <p className="mt-2 text-sm font-bold text-slate-700">
                  Gedung Utama
                </p>
                <p className="text-xs text-slate-400">
                  Area Sekolah
                </p>
              </div>

              <div className="rounded-2xl border border-white bg-white/90 p-5 text-center shadow-sm">
                <span className="text-3xl">📍</span>
                <p className="mt-2 text-sm font-bold text-slate-700">
                  Gedung Timur
                </p>
                <p className="text-xs text-slate-400">
                  Area Teknisi
                </p>
              </div>

              <div className="rounded-2xl border border-white bg-white/90 p-5 text-center shadow-sm">
                <span className="text-3xl">🌳</span>
                <p className="mt-2 text-sm font-bold text-slate-700">
                  Lapangan
                </p>
                <p className="text-xs text-slate-400">
                  Area Terbuka
                </p>
              </div>

              <div className="rounded-2xl border border-white bg-white/90 p-5 text-center shadow-sm">
                <span className="text-3xl">🏢</span>
                <p className="mt-2 text-sm font-bold text-slate-700">
                  Gedung Barat
                </p>
                <p className="text-xs text-slate-400">
                  Area Sekolah
                </p>
              </div>

            </div>
          </div>

          <div className="border-t border-slate-100 p-4">
            <p className="text-xs text-slate-400">
              Peta ini hanya ilustrasi. Lokasi GPS sebenarnya belum terhubung.
            </p>
          </div>
        </section>

        {/* DAFTAR TEKNISI */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Lokasi Teknisi
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Informasi berbagi lokasi teknisi
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau ID teknisi..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-72"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {["Semua", "Aktif", "Tidak Aktif"].map((item) => (
              <button
                key={item}
                onClick={() => setFilter(item)}
                className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                  filter === item
                    ? "bg-blue-600 text-white"
                    : "bg-slate-100 text-slate-600 hover:bg-slate-200"
                }`}
              >
                {item}
              </button>
            ))}
          </div>

          {/* TABEL */}
          <div className="mt-5 overflow-x-auto">
            <table className="w-full min-w-[750px] text-left text-sm">
              <thead>
                <tr className="border-b bg-slate-50 text-slate-500">
                  <th className="px-4 py-4">No</th>
                  <th className="px-4 py-4">Nama Teknisi</th>
                  <th className="px-4 py-4">ID Teknisi</th>
                  <th className="px-4 py-4">Wilayah</th>
                  <th className="px-4 py-4">Durasi</th>
                  <th className="px-4 py-4">Status</th>
                  <th className="px-4 py-4">Aksi</th>
                </tr>
              </thead>

              <tbody>
                {hasilFilter.map((item, index) => (
                  <tr
                    key={item.id}
                    className="border-b border-slate-100 hover:bg-slate-50"
                  >
                    <td className="px-4 py-4">{index + 1}</td>

                    <td className="px-4 py-4 font-semibold text-slate-700">
                      {item.nama}
                    </td>

                    <td className="px-4 py-4 text-slate-500">
                      {item.kode}
                    </td>

                    <td className="px-4 py-4 text-slate-600">
                      {item.wilayah}
                    </td>

                    <td className="px-4 py-4">
                      {item.durasi}
                    </td>

                    <td className="px-4 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Aktif"
                            ? "bg-green-100 text-green-700"
                            : "bg-slate-100 text-slate-500"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="px-4 py-4">
                      <button
                        onClick={() => setDipilih(item)}
                        className="rounded-lg bg-blue-50 px-3 py-2 text-xs font-semibold text-blue-600 hover:bg-blue-100"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                ))}

                {hasilFilter.length === 0 && (
                  <tr>
                    <td colSpan={7} className="px-4 py-10 text-center text-slate-400">
                      Teknisi tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* MODAL DETAIL */}
        {dipilih && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-xl">

              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Teknisi
                </h2>

                <button
                  onClick={() => setDipilih(null)}
                  className="text-2xl text-slate-400"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 space-y-4">

                <div>
                  <p className="text-xs text-slate-400">Nama Teknisi</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.nama}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">ID Teknisi</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.kode}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Wilayah</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.wilayah}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Durasi Berbagi Lokasi</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.durasi}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Terakhir Diperbarui</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.terakhir}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Status</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.status}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Baterai Perangkat (Contoh)</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.baterai}%
                  </p>
                </div>

              </div>

              <button
                onClick={() => setDipilih(null)}
                className="mt-6 w-full rounded-xl bg-slate-100 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-200"
              >
                Tutup
              </button>

            </div>
          </div>
        )}

      </div>
    </main>
  );
}
