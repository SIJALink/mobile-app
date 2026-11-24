
"use client";

import { useState } from "react";

type RiwayatQR = {
  id: number;
  nama: string;
  kode: string;
  jabatan: string;
  wilayah: string;
  tanggal: string;
  waktu: string;
  pemindai: string;
  status: "Berhasil" | "Gagal";
};

const dataAwal: RiwayatQR[] = [
  {
    id: 1,
    nama: "Andi Saputra",
    kode: "TKN-001",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Utama",
    tanggal: "22 November 2026",
    waktu: "07:30",
    pemindai: "Admin SIJALink",
    status: "Berhasil",
  },
  {
    id: 2,
    nama: "Budi Santoso",
    kode: "TKN-002",
    jabatan: "Petugas Lapangan",
    wilayah: "Area Timur",
    tanggal: "22 November 2026",
    waktu: "08:15",
    pemindai: "Guru Piket",
    status: "Berhasil",
  },
  {
    id: 3,
    nama: "Dedi Kurniawan",
    kode: "TKN-003",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Barat",
    tanggal: "22 November 2026",
    waktu: "09:20",
    pemindai: "Admin SIJALink",
    status: "Gagal",
  },
  {
    id: 4,
    nama: "Rizky Pratama",
    kode: "TKN-004",
    jabatan: "Supervisor",
    wilayah: "Area Selatan",
    tanggal: "21 November 2026",
    waktu: "10:00",
    pemindai: "Guru Piket",
    status: "Berhasil",
  },
  {
    id: 5,
    nama: "Fajar Ramadhan",
    kode: "TKN-005",
    jabatan: "Teknisi Lapangan",
    wilayah: "Area Utara",
    tanggal: "21 November 2026",
    waktu: "11:30",
    pemindai: "Admin SIJALink",
    status: "Gagal",
  },
];

export default function RiwayatQRPage() {
  const [data] = useState(dataAwal);
  const [cari, setCari] = useState("");
  const [filter, setFilter] = useState("Semua");
  const [dipilih, setDipilih] = useState<RiwayatQR | null>(null);

  const berhasil = data.filter(
    (item) => item.status === "Berhasil"
  ).length;

  const gagal = data.filter(
    (item) => item.status === "Gagal"
  ).length;

  const hasilFilter = data.filter((item) => {
    const cocokCari =
      item.nama.toLowerCase().includes(cari.toLowerCase()) ||
      item.kode.toLowerCase().includes(cari.toLowerCase());

    const cocokStatus =
      filter === "Semua" || item.status === filter;

    return cocokCari && cocokStatus;
  });

  return (
    <main className="min-h-screen bg-slate-100 p-4 md:p-8">
      <div className="mx-auto max-w-7xl space-y-6">

        {/* HEADER */}
        <div>
          <p className="text-sm font-medium text-blue-600">
            SIJALink / Riwayat Verifikasi QR
          </p>

          <h1 className="mt-2 text-2xl font-bold text-slate-800 md:text-3xl">
            Riwayat Verifikasi QR Petugas
          </h1>

          <p className="mt-2 text-sm text-slate-500">
            Pantau aktivitas pemindaian dan hasil verifikasi QR petugas.
          </p>
        </div>

        {/* STATISTIK */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Total Pemindaian
            </p>
            <h2 className="mt-3 text-3xl font-bold text-slate-800">
              {data.length}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              Seluruh aktivitas QR
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Verifikasi Berhasil
            </p>
            <h2 className="mt-3 text-3xl font-bold text-green-600">
              {berhasil}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              QR berhasil diverifikasi
            </p>
          </div>

          <div className="rounded-2xl bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">
              Verifikasi Gagal
            </p>
            <h2 className="mt-3 text-3xl font-bold text-red-500">
              {gagal}
            </h2>
            <p className="mt-2 text-xs text-slate-400">
              QR gagal diverifikasi
            </p>
          </div>

        </div>

        {/* TABEL RIWAYAT */}
        <section className="rounded-2xl bg-white p-5 shadow-sm md:p-6">

          <div className="flex flex-col justify-between gap-4 md:flex-row md:items-center">
            <div>
              <h2 className="text-lg font-bold text-slate-800">
                Daftar Riwayat Pemindaian
              </h2>
              <p className="mt-1 text-sm text-slate-500">
                Informasi aktivitas verifikasi QR petugas.
              </p>
            </div>

            <input
              type="text"
              placeholder="Cari nama atau ID petugas..."
              value={cari}
              onChange={(e) => setCari(e.target.value)}
              className="w-full rounded-xl border border-slate-200 px-4 py-3 text-sm outline-none focus:border-blue-500 md:w-72"
            />
          </div>

          {/* FILTER */}
          <div className="mt-5 flex flex-wrap gap-2">
            {["Semua", "Berhasil", "Gagal"].map((item) => (
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
            <table className="w-full min-w-[850px] text-left text-sm">
              <thead>
                <tr className="border-b bg-slate-50 text-slate-500">
                  <th className="px-4 py-4">No</th>
                  <th className="px-4 py-4">Nama Petugas</th>
                  <th className="px-4 py-4">ID Petugas</th>
                  <th className="px-4 py-4">Jabatan</th>
                  <th className="px-4 py-4">Tanggal</th>
                  <th className="px-4 py-4">Waktu</th>
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

                    <td className="px-4 py-4">
                      {item.jabatan}
                    </td>

                    <td className="px-4 py-4 text-slate-500">
                      {item.tanggal}
                    </td>

                    <td className="px-4 py-4">
                      {item.waktu}
                    </td>

                    <td className="px-4 py-4">
                      <span
                        className={`rounded-full px-3 py-1 text-xs font-semibold ${
                          item.status === "Berhasil"
                            ? "bg-green-100 text-green-700"
                            : "bg-red-100 text-red-700"
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
                    <td
                      colSpan={8}
                      className="px-4 py-10 text-center text-slate-400"
                    >
                      Riwayat tidak ditemukan.
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
                  Detail Verifikasi QR
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
                  <p className="text-xs text-slate-400">Nama Petugas</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.nama}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">ID Petugas</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.kode}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Jabatan</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.jabatan}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Wilayah</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.wilayah}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Tanggal dan Waktu</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.tanggal}, {dipilih.waktu}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Dipindai Oleh</p>
                  <p className="font-semibold text-slate-800">
                    {dipilih.pemindai}
                  </p>
                </div>

                <div>
                  <p className="text-xs text-slate-400">Hasil Verifikasi</p>
                  <span
                    className={`mt-1 inline-block rounded-full px-3 py-1 text-xs font-semibold ${
                      dipilih.status === "Berhasil"
                        ? "bg-green-100 text-green-700"
                        : "bg-red-100 text-red-700"
                    }`}
                  >
                    {dipilih.status}
                  </span>
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
