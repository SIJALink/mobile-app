
"use client";

import { useState } from "react";

type Laporan = {
  id: number;
  nama: string;
  tanggal: string;
  kelas: string;
  kegiatan: string;
  selesai: number;
  total: number;
  status: string;
  catatan: string;
  pemeriksaan: string;
};

const dataAwal: Laporan[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    tanggal: "22 November 2026",
    kelas: "X RPL 1",
    kegiatan: "Pemeriksaan kebersihan kelas",
    selesai: 8,
    total: 8,
    status: "Menunggu Pemeriksaan",
    catatan: "Seluruh kegiatan piket berjalan dengan baik.",
    pemeriksaan: "",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    tanggal: "22 November 2026",
    kelas: "XI RPL 2",
    kegiatan: "Pemeriksaan kedisiplinan siswa",
    selesai: 6,
    total: 8,
    status: "Menunggu Pemeriksaan",
    catatan: "Beberapa kegiatan belum dilengkapi.",
    pemeriksaan: "",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    tanggal: "21 November 2026",
    kelas: "XII RPL 1",
    kegiatan: "Pengawasan kegiatan siswa",
    selesai: 8,
    total: 8,
    status: "Disetujui",
    catatan: "Kegiatan berjalan dengan lancar.",
    pemeriksaan: "Laporan sudah sesuai.",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    tanggal: "21 November 2026",
    kelas: "XI RPL 1",
    kegiatan: "Pemeriksaan lingkungan sekolah",
    selesai: 5,
    total: 8,
    status: "Perlu Revisi",
    catatan: "Dokumentasi kegiatan belum lengkap.",
    pemeriksaan: "Mohon lengkapi dokumentasi.",
  },
];

export default function PemeriksaanLaporanPage() {
  const [laporan, setLaporan] = useState(dataAwal);
  const [dipilih, setDipilih] = useState<Laporan | null>(null);
  const [catatan, setCatatan] = useState("");
  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");

  const total = laporan.length;

  const menunggu = laporan.filter(
    (item) => item.status === "Menunggu Pemeriksaan"
  ).length;

  const disetujui = laporan.filter(
    (item) => item.status === "Disetujui"
  ).length;

  const revisi = laporan.filter(
    (item) => item.status === "Perlu Revisi"
  ).length;

  const hasilFilter = laporan.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.kelas.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  function simpanPemeriksaan(statusBaru: string) {
    if (!dipilih) return;

    if (!catatan.trim()) {
      alert("Silakan isi catatan pemeriksaan terlebih dahulu.");
      return;
    }

    const laporanDiperbarui = laporan.map((item) =>
      item.id === dipilih.id
        ? {
            ...item,
            status: statusBaru,
            pemeriksaan: catatan,
          }
        : item
    );

    setLaporan(laporanDiperbarui);
    setDipilih(null);
    setCatatan("");
  }

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Kepala SITE / Pemeriksaan Laporan
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Pemeriksaan Laporan Guru Piket
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Periksa laporan kegiatan dan berikan keputusan terhadap laporan Guru Piket.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Total Laporan</p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {total}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Semua laporan masuk
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Menunggu Pemeriksaan</p>
            <h2 className="mt-3 text-3xl font-bold text-orange-500">
              {menunggu}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Belum diperiksa
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Disetujui</p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {disetujui}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Laporan diterima
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Perlu Revisi</p>
            <h2 className="mt-3 text-3xl font-bold text-red-500">
              {revisi}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Perlu diperbaiki
            </p>
          </div>

        </div>

        {/* DAFTAR LAPORAN */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Laporan Masuk
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Pilih laporan untuk melakukan pemeriksaan.
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau kelas..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-64"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {[
              "Semua",
              "Menunggu Pemeriksaan",
              "Disetujui",
              "Perlu Revisi",
            ].map((item) => (
              <button
                key={item}
                onClick={() => setFilter(item)}
                className={`rounded-xl px-4 py-2 text-xs font-semibold ${
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
                  <th className="px-4 py-4">Nama Guru Piket</th>
                  <th className="px-4 py-4">Tanggal</th>
                  <th className="px-4 py-4">Kelas</th>
                  <th className="px-4 py-4">Checklist</th>
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
                      {item.tanggal}
                    </td>

                    <td className="px-4 py-4">{item.kelas}</td>

                    <td className="px-4 py-4">
                      {item.selesai}/{item.total}
                    </td>

                    <td className="px-4 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Disetujui"
                            ? "bg-green-100 text-green-700"
                            : item.status === "Perlu Revisi"
                            ? "bg-red-100 text-red-700"
                            : "bg-orange-100 text-orange-700"
                        }`}
                      >
                        {item.status}
                      </span>
                    </td>

                    <td className="px-4 py-4">
                      <button
                        onClick={() => {
                          setDipilih(item);
                          setCatatan(item.pemeriksaan);
                        }}
                        className="rounded-lg bg-blue-50 px-3 py-2 text-xs font-semibold text-blue-600 hover:bg-blue-100"
                      >
                        Periksa
                      </button>
                    </td>
                  </tr>
                ))}

                {hasilFilter.length === 0 && (
                  <tr>
                    <td colSpan={7} className="px-4 py-10 text-center text-slate-400">
                      Laporan tidak ditemukan.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        {/* MODAL PEMERIKSAAN */}
        {dipilih && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="max-h-[90vh] w-full max-w-lg overflow-y-auto rounded-2xl bg-white p-6 shadow-xl">

              <div className="flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-800">
                  Detail Pemeriksaan
                </h2>

                <button
                  onClick={() => setDipilih(null)}
                  className="text-2xl text-slate-400 hover:text-slate-700"
                >
                  ×
                </button>
              </div>

              <div className="mt-5 space-y-4">

                <div>
                  <p className="text-xs text-slate-400">Nama Guru Piket</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.nama}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Tanggal</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.tanggal}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Kelas</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.kelas}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Kegiatan</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.kegiatan}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Checklist Selesai</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.selesai} dari {dipilih.total} kegiatan
                  </p>

                  <div className="mt-2 h-2 rounded-full bg-slate-100">
                    <div
                      className="h-2 rounded-full bg-blue-600"
                      style={{
                        width: `${(dipilih.selesai / dipilih.total) * 100}%`,
                      }}
                    />
                  </div>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Catatan Guru Piket</p>
                  <p className="text-sm text-slate-700">
                    {dipilih.catatan}
                  </p>
                </div>

                <div>
                  <label className="text-sm font-semibold text-slate-700">
                    Catatan Pemeriksaan Kepala SITE
                  </label>

                  <textarea
                    value={catatan}
                    onChange={(e) => setCatatan(e.target.value)}
                    placeholder="Tuliskan hasil pemeriksaan..."
                    rows={4}
                    className="mt-2 w-full rounded-xl border border-slate-200 p-3 text-sm outline-none focus:border-blue-500"
                  />
                </div>

              </div>

              <div className="mt-6 grid grid-cols-1 gap-3 sm:grid-cols-2">
                <button
                  onClick={() => simpanPemeriksaan("Disetujui")}
                  className="rounded-xl bg-green-600 px-4 py-3 text-sm font-semibold text-white hover:bg-green-700"
                >
                  Setujui Laporan
                </button>

                <button
                  onClick={() => simpanPemeriksaan("Perlu Revisi")}
                  className="rounded-xl bg-orange-500 px-4 py-3 text-sm font-semibold text-white hover:bg-orange-600"
                >
                  Minta Revisi
                </button>
              </div>

              <button
                onClick={() => setDipilih(null)}
                className="mt-3 w-full rounded-xl bg-slate-100 px-4 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-200"
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
