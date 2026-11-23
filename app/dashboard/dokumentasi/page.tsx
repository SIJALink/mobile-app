
"use client";

import { useState } from "react";

type Dokumentasi = {
  id: number;
  nama: string;
  kelas: string;
  tanggal: string;
  waktu: string;
  kegiatan: string;
  jenis: "Foto" | "Video";
  file: string;
};

const dataDokumentasi: Dokumentasi[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    kelas: "X RPL 1",
    tanggal: "22 November 2026",
    waktu: "07:30",
    kegiatan: "Pemeriksaan kebersihan ruang kelas",
    jenis: "Foto",
    file: "https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    kelas: "XI RPL 2",
    tanggal: "22 November 2026",
    waktu: "08:15",
    kegiatan: "Pemeriksaan lingkungan sekolah",
    jenis: "Foto",
    file: "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=900",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    kelas: "XII RPL 1",
    tanggal: "21 November 2026",
    waktu: "09:00",
    kegiatan: "Dokumentasi kegiatan piket pagi",
    jenis: "Video",
    file: "",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    kelas: "XI RPL 1",
    tanggal: "21 November 2026",
    waktu: "10:20",
    kegiatan: "Pengawasan kebersihan halaman",
    jenis: "Foto",
    file: "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=900",
  },
];

export default function DokumentasiPage() {
  const [data] = useState(dataDokumentasi);
  const [filter, setFilter] = useState("Semua");
  const [cari, setCari] = useState("");
  const [dipilih, setDipilih] = useState<Dokumentasi | null>(null);

  const hasilFilter = data.filter((item) => {
    const cocokFilter =
      filter === "Semua" || item.jenis === filter;

    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.kegiatan.toLowerCase().includes(cari.toLowerCase());

    return cocokFilter && cocokCari;
  });

  const totalFoto = data.filter((item) => item.jenis === "Foto").length;
  const totalVideo = data.filter((item) => item.jenis === "Video").length;

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Dokumentasi
          </p>
          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Dokumentasi Foto & Video
          </h1>
          <p className="mt-2 text-sm text-slate-500">
            Kelola dan pantau bukti kegiatan Guru Piket.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Dokumentasi</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Semua dokumentasi masuk
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Dokumentasi Foto</p>
            <h2 className="mt-3 text-3xl font-bold text-blue-600">
              {totalFoto}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Foto kegiatan Guru Piket
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Dokumentasi Video</p>
            <h2 className="mt-3 text-3xl font-bold text-purple-600">
              {totalVideo}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Video kegiatan Guru Piket
            </p>
          </div>
        </div>

        {/* GALERI */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">
          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Galeri Dokumentasi
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Bukti foto dan video kegiatan
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau kegiatan..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-72"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {["Semua", "Foto", "Video"].map((item) => (
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

          {/* CARD GALERI */}
          <div className="mt-6 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {hasilFilter.map((item) => (
              <div
                key={item.id}
                className="overflow-hidden rounded-2xl border border-slate-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-md"
              >
                <div className="relative h-48 bg-slate-200">
                  {item.jenis === "Foto" ? (
                    <img
                      src={item.file}
                      alt={item.kegiatan}
                      className="h-full w-full object-cover"
                    />
                  ) : (
                    <div className="flex h-full flex-col items-center justify-center bg-slate-800 text-white">
                      <span className="text-5xl">▶</span>
                      <p className="mt-3 text-sm font-medium">
                        Dokumentasi Video
                      </p>
                    </div>
                  )}

                  <span className="absolute right-3 top-3 rounded-full bg-white px-3 py-1 text-xs font-bold text-blue-600 shadow">
                    {item.jenis}
                  </span>
                </div>

                <div className="space-y-3 p-4">
                  <div>
                    <h3 className="font-bold text-slate-800">
                      {item.kegiatan}
                    </h3>
                    <p className="mt-1 text-sm text-slate-500">
                      {item.nama} • {item.kelas}
                    </p>
                  </div>

                  <div className="flex justify-between text-xs text-slate-400">
                    <span>{item.tanggal}</span>
                    <span>{item.waktu}</span>
                  </div>

                  <button
                    onClick={() => setDipilih(item)}
                    className="w-full rounded-xl bg-blue-50 px-4 py-3 text-sm font-semibold text-blue-600 hover:bg-blue-100"
                  >
                    Lihat Detail
                  </button>
                </div>
              </div>
            ))}
          </div>

          {hasilFilter.length === 0 && (
            <p className="py-12 text-center text-sm text-slate-400">
              Dokumentasi tidak ditemukan.
            </p>
          )}
        </section>

        {/* MODAL DETAIL */}
        {dipilih && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
            <div className="max-h-[90vh] w-full max-w-xl overflow-y-auto rounded-2xl bg-white p-6">
              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Dokumentasi
                </h2>
                <button
                  onClick={() => setDipilih(null)}
                  className="text-2xl text-slate-400"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 overflow-hidden rounded-xl bg-slate-100">
                {dipilih.jenis === "Foto" ? (
                  <img
                    src={dipilih.file}
                    alt={dipilih.kegiatan}
                    className="max-h-80 w-full object-contain"
                  />
                ) : (
                  <div className="flex h-48 items-center justify-center text-slate-500">
                    Video belum tersedia pada data contoh.
                  </div>
                )}
              </div>

              <div className="mt-5 space-y-3 text-sm">
                <p>
                  <span className="text-slate-400">Nama:</span>{" "}
                  <b>{dipilih.nama}</b>
                </p>
                <p>
                  <span className="text-slate-400">Kelas:</span>{" "}
                  <b>{dipilih.kelas}</b>
                </p>
                <p>
                  <span className="text-slate-400">Tanggal:</span>{" "}
                  <b>{dipilih.tanggal}</b>
                </p>
                <p>
                  <span className="text-slate-400">Waktu:</span>{" "}
                  <b>{dipilih.waktu}</b>
                </p>
                <p>
                  <span className="text-slate-400">Kegiatan:</span>{" "}
                  <b>{dipilih.kegiatan}</b>
                </p>
                <p>
                  <span className="text-slate-400">Jenis:</span>{" "}
                  <b>{dipilih.jenis}</b>
                </p>
              </div>

              <button
                onClick={() => setDipilih(null)}
                className="mt-6 w-full rounded-xl bg-slate-100 py-3 font-semibold text-slate-600 hover:bg-slate-200"
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
